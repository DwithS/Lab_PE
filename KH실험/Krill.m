classdef Bird
%     
%   
    properties
        selector;
        newSelector;
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
            [obj.feature] = [Data.X];
            [obj.class] = [Data.Y];
            obj.algo = Algo;
            obj.seq = Seq;
        end
        
        function obj = refresh(obj)
            obj.velocity = obj.newVelocity;
            obj.selector = obj.newSelector;
        end
    
        function obj = modi_velocity(obj, obj_Best, obj_Neighbor)
            obj.newVelocity = obj.velocity + Bird.VarA*(obj.selector -obj_Best.selector) + Bird.VarB*(obj.selector - obj_Neighbor.selector);
        end
        
        function obj = modi_selector(obj)
            obj.newSelector = obj.selector + obj.newVelocity;
            for i=1:length(obj.selector)
                if obj.newSelector(i)<=0;
                    obj.newSelector(i)=0;
                else
                    if rand(1)>obj.newSelector(i)/2
                        obj.newSelector(i)=0;
                    end
                end
            end
            
        end
        
        function result_mean = getResult(obj)
            temp_feature = obj.feature(:,logical(obj.selector));
            result = classifer(temp_feature, obj.class , obj.seq, obj.algo);
            result_mean = mean(result(:,1));
        end
    end
end