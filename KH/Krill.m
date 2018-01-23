classdef Krill
%     
%   
    properties
        selector;
        newSelector;
        motioN_by_other
        motioN_by_other_Max
        Foraging_motion
        physical_Diffusion
        B_food_attractive
        B_food_attractive_best %best val when has best fitness
        feature;
        class;
        velocity;
        newVelocity;
        algo;
        seq;
        fitness
        fitness_best
        pureData
        
    end
    
    
    properties(Constant)
        
%         VarA = 0.6;
%         VarB = 0.7;
    
    end
    
    methods
        function obj = setData(obj, Data, Algo, Seq)
            [obj.pureData] = Data;
            [obj.feature] = [Data.X];
            [obj.class] = [Data.Y];
            obj.algo = Algo;
            obj.seq = Seq;
        end
        
        function obj = refresh(obj)
            
        end
    
        function obj = modi_velocity(obj, obj_Best, obj_Neighbor)
            
        end
        
        function obj = modi_selector(obj)
            
        end
        
        function result_mean = getResult(obj)
            temp_feature = obj.feature(:,logical(obj.selector));
            result = classifer(temp_feature, obj.class , obj.seq, obj.algo);
             
            result_mean = mean(result(:,1));
            
        end
    end
end