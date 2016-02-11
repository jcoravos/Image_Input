function [SigInt_interp,SigInt_areanorm_interp,Area_interp] = interpEdge(Ii,Oi)
%%This function simply takes the Input and Output structures and feeds them
%%into the matlab interp1 function. This is a precursor to merging data.
            x = (0:Ii.timestep:Oi.frame_num*Ii.timestep-1);
            x_Rok = (Oi.SigInt);
            x_Roknorm = Oi.SigInt_areanorm;
            x_Area = Oi.Area;
                % generating query time points
                xq = (0:1:Oi.frame_num*Ii.timestep);
        SigInt_interp = interp1(x,x_Rok,xq);
        SigInt_areanorm_interp = interp1(x,x_Roknorm,xq);
        Area_interp = interp1(x,x_Area,xq);

end