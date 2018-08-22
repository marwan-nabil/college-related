function LZW

from_source='abbbccccbabbcbbbcaaaacbbbb';
%initial values
lut={'a','b','c'};
i=2;
string=from_source(1);
output=[];
j=4;
%loop on the input
while i<=length(from_source)
    symbol=from_source(i);
    i=i+1;

    code=find(strcmp(lut,strcat(string,symbol)));
        if (isempty(code)==0)
            string=strcat(string,symbol);
        else 
            output=cat(2,output,find(strcmp(lut,string)));
            lut(j)={strcat(string,symbol)};
            j=j+1;
            string=symbol;
        end
        output
        
end
