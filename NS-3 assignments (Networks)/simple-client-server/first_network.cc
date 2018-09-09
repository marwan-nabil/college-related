
#include "build/ns3/core-module.h"
#include "build/ns3/network-module.h"
#include "build/ns3/internet-module.h"
#include "build/ns3/point-to-point-module.h"
#include "build/ns3/applications-module.h"
#include <string>
#include <string.h>
#include <iostream>
/*            point-to-point-link
*   node1----------------------------node2
*     |udpClient1                      |udpServer1
*     |udpClient2                      |udpServer2       
*
*/



/*  pseudocode (first 3 steps of the requirements)

setup nodes and pp-link;
add a UDP client and server on both nodes with given rate(5mbps) and default latency(2ms);
start simulation;
print initial results (packet traces and latency and throughput info);
stop simulation;

for (10 times)
    change latency;
    start simulation;
    measure throughput and print it with the latency;
    stop simulation;

add another udp server/client pair on both nodes with contrasting port numbers;

for (10 times)
    change latency;
    start simulation;
    measure throughput and print it with the latency;
    stop simulation;

end;
*/

auto rate1 ="5Mbps";
//auto latency1 = "2ms";

using namespace ns3;

NS_LOG_COMPONENT_DEFINE ("FirstScriptExample");

int
main (int argc, char *argv[])
{
    //initial setup
  Time::SetResolution (Time::MS);
  LogComponentEnable ("UdpEchoClientApplication", LOG_LEVEL_INFO);
  LogComponentEnable ("UdpEchoServerApplication", LOG_LEVEL_INFO);
    //create 2 nodes
  NodeContainer nodes;
  nodes.Create (2);
    //create a pp-link with default params
  PointToPointHelper pointToPoint;
  pointToPoint.SetDeviceAttribute ("DataRate", StringValue (rate1));
  pointToPoint.SetChannelAttribute ("Delay", StringValue (std::to_string(2)+"ms"));
    //create network devices on the nodes (interface between nodes and the channel "pp-devices")
  NetDeviceContainer devices;
  devices = pointToPoint.Install (nodes);
    //installing the ip stack on both nodes
  InternetStackHelper stack;
  stack.Install (nodes);
  Ipv4AddressHelper address;
  address.SetBase ("10.1.1.0", "255.255.255.0");
  Ipv4InterfaceContainer interfaces = address.Assign (devices); //auto-assigns ip addresses to the devices
    
////////////////////////////////////////////////////////////////////////////////////////  
    //create and install a udp sever with port 2
  UdpEchoServerHelper echoServer1 (2);
  ApplicationContainer serverApps1 = echoServer1.Install (nodes.Get (1));
  serverApps1.Start (Seconds (1.0)); //app start time, relative to simulation time
  serverApps1.Stop (Seconds (10.0)); //app stop time
    //create and install a udp client with port 2
  UdpEchoClientHelper echoClient1 (interfaces.GetAddress (1), 2);
  echoClient1.SetAttribute ("MaxPackets", UintegerValue (5));
  echoClient1.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient1.SetAttribute ("PacketSize", UintegerValue (1024));
  ApplicationContainer clientApps1 = echoClient1.Install (nodes.Get (0));
  clientApps1.Start (Seconds (2.0));
  clientApps1.Stop (Seconds (10.0));
////////////////////////////////////////////////////////////////////////////////////////  
  
  
  
  pointToPoint.EnablePcapAll ("network1");

    //run this initial test
  Simulator::Run ();
    // TODO: display throughput and latency
  Simulator::Destroy ();

    // second part of the test (changing latency and measuring throughput)
    for (int i =0;i<10;i++){
        pointToPoint.SetChannelAttribute ("Delay", StringValue (std::to_string(2+i*5)+"ms"));
        Simulator::Run ();
        // TODO: display throughput and latency
        Simulator::Destroy ();
    }
    
    // third part: add another client/server pair without conflicts
    // this is done by using another different port address
////////////////////////////////////////////////////////////////////////////////////////  
    //create and install a udp sever with port 5
  UdpEchoServerHelper echoServer2 (5);
  ApplicationContainer serverApps2 = echoServer2.Install (nodes.Get (1));
  serverApps2.Start (Seconds (1.0)); //app start time, relative to simulation time
  serverApps2.Stop (Seconds (10.0)); //app stop time
    //create and install a udp client with port 5
  UdpEchoClientHelper echoClient2 (interfaces.GetAddress (1), 5);
  echoClient2.SetAttribute ("MaxPackets", UintegerValue (3));
  echoClient2.SetAttribute ("Interval", TimeValue (Seconds (1.0)));
  echoClient2.SetAttribute ("PacketSize", UintegerValue (1024));
  ApplicationContainer clientApps2 = echoClient2.Install (nodes.Get (0));
  clientApps2.Start (Seconds (2.0));
  clientApps2.Stop (Seconds (10.0));
////////////////////////////////////////////////////////////////////////////////////////    
    // second part of the test (changing latency and measuring throughput)
    for (int i =0;i<10;i++){
        pointToPoint.SetChannelAttribute ("Delay", StringValue (std::to_string(2+i*5)+"ms"));
        Simulator::Run ();
        // TODO: display throughput and latency
        Simulator::Destroy ();
    }
  return 0;
}
