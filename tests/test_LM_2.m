addpath('../lib');
addpath('../maps');
addpath('../functions');

%% Trivial test
funTest1 = Barrier1();

LM1 = MinimizationLevembergMarquardt( funTest1 );
LM1.save_iterate_on();
LM1.setTolerance(1e-6);
LM1.setEpsilon2(1e-10);
LM1.setTau(1e-4);
LM1.setMaxIteration(int32(1000));

funTest1.contour([-1.5 1.5],[-1.5 1.5], 80, true);

t = 0:2*pi/1000:2*pi;
hold on;
plot(cos(t),sin(t),'-b','Linewidth',2);
axis equal;


%x0 = r.guess(int32(1));
x0 = [0; 0.999993944545];
%x0 = [0; 0.9];
[x_star,converged] = LM1.minimize(x0);
LM1.plotIter();

x0 = [0; 0.8];
[x_star,converged] = LM1.minimize(x0);
LM1.plotIter();

title('Levemberg Marquardt');
