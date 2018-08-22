%%%%%%%%%%%%%%%%%%%%%% polygon specification %%%%%%%%%%%%%%%%%%%
fprintf('*************** 2D linear transformation program starting *************** \n');
sides=input('Enter the number of sides of the original polygon >>');
polygon=zeros(2,sides);  % preallocation

fprintf('\n Data entry for each vertex,if left empty defaul is zero');
fprintf('\n \n');
for i=1:sides            % forming the polygon matrix (2 X sides)
fprintf('Enter data for vertex %d \n',i);
polygon([1 2],i)=[input('enter x coordinate >> ');input('enter y coordinate >> ')];
fprintf('\n');
end


%%%%%%%%%%%%%%%%%%%%%% transformations %%%%%%%%%%%%%%%%%%%

fprintf('Select your transformation(s) or click Done to perform the selected ones \n');
global polygon_;        % so that it can be accessed by the functions
polygon_=polygon;       % initial image of the polygon    

while(1)                % transformation choices            
choice=menu('select a transformation','1-Done','2-Scaling','3-translation','4-Rotation around origin','5-Reflecting on x axis','6-Reflecting on y axis','7-shear in x-direction','8-shear in y-direction','9-rotation around the first vertex','10-reflection on line y=x','11-reflection on line y=-x');
    if choice==1        % Done condition
        break
    elseif choice==2    % all transformations are performed by the corresponding functions
        scale_poly();   
    elseif choice==3
        translate_poly();
    elseif choice==4
        rotate_poly();
    elseif choice==5
        ref_x();
    elseif choice==6
        ref_y();
    elseif choice==7
        shear_x();
    elseif choice==8     
        shear_y();
    elseif choice==9
        rot_round_first();
    elseif choice==10
        ref_on_line_x();
    elseif choice==11
        ref_on_line_negx();
    %%% add any transformation you desire in an 'elsif' but write it's function beforehand 
    else
        break
        
          
    end
end


%%%%%%%%%%%%%%%%%%%%%% plotting the polygon and it's image %%%%%%%%%%%%%%%%%%%
% starts executing at the DONE condition
fprintf('original polygon will be diplayed in red, image in blue \n press any key to continue...');
input('');

plot([polygon(1,1:end) polygon(1,1)],[polygon(2,1:end) polygon(2,1)],'Color','r');     % original
hold on
plot([polygon_(1,1:end) polygon_(1,1)],[polygon_(2,1:end) polygon_(2,1)],'color','b'); % image


%subplot(1,2,1);
%fill(polygon(1,:),polygon(2,:),'r');   % original
%subplot(1,2,2);
%fill(polygon_(1,:),polygon_(2,:),'b'); % image

% transformation functions are defined in separate files because>> MATLAB !!!!












