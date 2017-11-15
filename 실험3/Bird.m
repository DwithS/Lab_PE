classdef Bird
%     
%   
    properties
        selector;
        
        pureData;
        feature;
        class;
        velocity;
        newVelocity;
        algo;
        seq;
    end
    
    
    properties(Constant)
        
        VarA = 0.6;
        VarB = 0.7;
    
    end
    
    methods
        function obj = setData(obj, Data,Algo,Seq)
            [obj.pureData] = Data;
            [obj.feature] = [Data.x];
            [obj.class] = [Data.y];
            obj.algo = Algo;
            obj.seq = Seq;
        end
    
        function obj = modi_velocity(obj, obj_Best, obj_Neighbor)
            obj.velocity = obj.velocity + Bird.VarA*(obj.feature -obj_Best.feature) + Bird.VarB*(obj.feature - obj_Neighbor.feature);
        end
        
        function obj = modi_selector(obj)
            obj.selector = obj.selector + obj.velocity;
        end
        
        function result_mean = getResult(obj)
            result = classifer(obj.feature, obj.class , obj.seq, obj.algo);
            result_mean = mean(result(:,1));
        end
    end
end