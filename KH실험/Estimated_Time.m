% Estimated TIme

 NUM_OF_ALGO = 4;
TESTNUM = 50;
TESTPORTION = 0.2;
NUM_OF_BIRD = 10;
PSO_THRESHOLD = 15;

C = 74.9070;

Estimated_time = C* (NUM_OF_ALGO*TESTNUM*TESTPORTION*NUM_OF_BIRD*PSO_THRESHOLD)/3600;
disp(Estimated_time+"hours");
disp(Estimated_time/24+"Days");