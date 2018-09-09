
#include <iostream>
#include <cstring>
#include <ns3/core-module.h>
#include <ns3/network-module.h>
#include <ns3/internet-module.h>
#include <ns3/point-to-point-module.h>
#include <ns3/mobility-module.h>
#include <ns3/config-store.h>
#include <ns3/applications-module.h>
#include <ns3/netanim-module.h>
#include <ns3/flow-monitor-module.h>
#include <iomanip>
#include <vector>
#include "ns3/wifi-module.h"


// Network Topology
//
//   Wifi 10.1.2.0
//                 AP
//			*))))((((((*
//			|				   |    10.1.1.0
//		 	n3			  n2 -------------- n1
//                   point-to-point  

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("assignment-2-wifi-pt1");

void ThroughputMonitor (FlowMonitorHelper *, Ptr<FlowMonitor>);

int main (int argc, char *argv[])
{
  NS_LOG_UNCOND ("wifi simulation");
//
//preparing topology
//

	NodeContainer p2pNodes;
  p2pNodes.Create (2);
  PointToPointHelper pointToPoint;
  pointToPoint.SetDeviceAttribute ("DataRate", StringValue ("5Mbps"));
  pointToPoint.SetChannelAttribute ("Delay", StringValue ("2ms"));
  NetDeviceContainer p2pDevices;
  p2pDevices = pointToPoint.Install (p2pNodes);
  
  NodeContainer wifiStaNodes;
  wifiStaNodes.Create (1);
  NodeContainer wifiApNode = p2pNodes.Get (1);
  
	YansWifiChannelHelper channel = YansWifiChannelHelper::Default ();
  YansWifiPhyHelper phy = YansWifiPhyHelper::Default ();
  phy.SetChannel (channel.Create ());
  
	WifiHelper wifi;
  wifi.SetRemoteStationManager ("ns3::AarfWifiManager");

  WifiMacHelper mac;
  Ssid ssid = Ssid ("ns-3-ssid");
  mac.SetType ("ns3::StaWifiMac",
               "Ssid", SsidValue (ssid),
               "ActiveProbing", BooleanValue (false));

  NetDeviceContainer staDevices;
  staDevices = wifi.Install (phy, mac, wifiStaNodes);

	mac.SetType ("ns3::ApWifiMac",
               "Ssid", SsidValue (ssid));

  NetDeviceContainer apDevices;
  apDevices = wifi.Install (phy, mac, wifiApNode);

//
//mobility stuff
//

	MobilityHelper mobility;

  mobility.SetPositionAllocator ("ns3::GridPositionAllocator",
                                 "MinX", DoubleValue (0.0),
                                 "MinY", DoubleValue (0.0),
                                 "DeltaX", DoubleValue (5.0),
                                 "DeltaY", DoubleValue (10.0),
                                 "GridWidth", UintegerValue (3),
                                 "LayoutType", StringValue ("RowFirst"));

  //mobility.SetMobilityModel ("ns3::RandomWalk2dMobilityModel",
                             //"Bounds", RectangleValue (Rectangle (-50, 50, -50, 50)));

	mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");

	//mobility.SetMobilityModel ("ns3::RandomDirection2dMobilityModel",
                                 //"Bounds", RectangleValue (Rectangle (-10, 10, -10, 10)),
                                 //"Speed", StringValue ("ns3::ConstantRandomVariable[Constant=3]"),
                                 //"Pause", StringValue ("ns3::ConstantRandomVariable[Constant=0.4]"));
  mobility.Install (wifiStaNodes);

  mobility.SetMobilityModel ("ns3::ConstantPositionMobilityModel");
  mobility.Install (wifiApNode);	// access point is stationary

//
// ip stack
//

	InternetStackHelper stack;
  stack.Install (p2pNodes);
  stack.Install (wifiStaNodes);
  
	Ipv4AddressHelper address;

  address.SetBase ("10.1.1.0", "255.255.255.0");
  Ipv4InterfaceContainer p2pInterfaces;
  p2pInterfaces = address.Assign (p2pDevices);

  address.SetBase ("10.1.2.0", "255.255.255.0");
  Ipv4InterfaceContainer wifiInterfaces;
  wifiInterfaces = address.Assign (staDevices);
  address.Assign (apDevices);
  
//
// udp stack
//  

	UdpEchoServerHelper echoServer (9);
  ApplicationContainer serverApps = echoServer.Install (p2pNodes.Get (0));
  serverApps.Start (Seconds (1.0));
  serverApps.Stop (Seconds (20.0));

  UdpEchoClientHelper echoClient (p2pInterfaces.GetAddress (0),9);
  echoClient.SetAttribute ("MaxPackets", UintegerValue (15));
  echoClient.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient.SetAttribute ("PacketSize", UintegerValue (1024));

  ApplicationContainer clientApps = 
    echoClient.Install (wifiStaNodes.Get (0));
  clientApps.Start (Seconds (2.0));
  clientApps.Stop (Seconds (20.0));
// populate routing tables
  Ipv4GlobalRoutingHelper::PopulateRoutingTables ();


//
//flow monitor and simulation stuff  
//

	Ptr<FlowMonitor> flowMonitor;
	FlowMonitorHelper flowHelper;

	//NodeContainer flowmon_nodes;
	//flowmon_nodes.Add(p2pNodes.Get (0));
	//flowMonitor = flowHelper.Install(flowmon_nodes);
	flowMonitor = flowHelper.InstallAll();

	//schedule the flow monitor
	Simulator::Schedule(Seconds(4),&ThroughputMonitor,&flowHelper, flowMonitor);
	//setup and start simulation
	pointToPoint.EnablePcapAll ("assignment-2-wifi-pt1-ppp");
	phy.EnablePcapAll ("assignment-2-wifi-pt1-phy");
	Simulator::Stop (Seconds(20));
  Simulator::Run ();
  Simulator::Destroy ();
}


void ThroughputMonitor (FlowMonitorHelper *fmhelper, Ptr<FlowMonitor> flowMon)
	{
		std::map<FlowId, FlowMonitor::FlowStats> flowStats = flowMon->GetFlowStats();
		Ptr<Ipv4FlowClassifier> classing = DynamicCast<Ipv4FlowClassifier> (fmhelper->GetClassifier());
		for (std::map<FlowId, FlowMonitor::FlowStats>::const_iterator stats = flowStats.begin (); stats != flowStats.end (); ++stats)
		{
			Ipv4FlowClassifier::FiveTuple fiveTuple = classing->FindFlow (stats->first);
			std::cout<<"Flow ID			: " << stats->first <<" ; "<< fiveTuple.sourceAddress <<" -----> "<<fiveTuple.destinationAddress<<std::endl;
//			std::cout<<"Tx Packets = " << stats->second.txPackets<<std::endl;
//			std::cout<<"Rx Packets = " << stats->second.rxPackets<<std::endl;
			std::cout<<"Duration		: "<<stats->second.timeLastRxPacket.GetSeconds()-stats->second.timeFirstTxPacket.GetSeconds()<<std::endl;
			std::cout<<"Last Received Packet	: "<< stats->second.timeLastRxPacket.GetSeconds()<<" Seconds"<<std::endl;
			std::cout<<"Throughput: " << stats->second.rxBytes * 8.0 / (stats->second.timeLastRxPacket.GetSeconds()-stats->second.timeFirstTxPacket.GetSeconds())/1024/1024  << " Mbps"<<std::endl;
			std::cout<<"---------------------------------------------------------------------------"<<std::endl;
		}
			Simulator::Schedule(Seconds(1),&ThroughputMonitor, fmhelper, flowMon);

	}
