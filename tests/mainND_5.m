clear all;
close all;
clc;

warning('on');

addpath('../lib');
addpath('../functions');

r = Barrier1();

%search_method   = LinesearchGoldenSection();
search_method   = LinesearchMoreThuente();
%search_method = LinesearchArmijo();
%search_method = LinesearchWolfe();

%search_method.debug_on();
minimization_method = MinimizationQuasiNewton( r, search_method );
minimization_method.setMaxIteration( int32(400) );
minimization_method.setTolerance(1e-8);
minimization_method.save_iterate_on();
%minimization_method.selectByName('DFP');

t = 0:2*pi/1000:2*pi;

subplot(1,2,1);
r.contour([-1.5 1.5],[-1.5 1.5], 80, @(x) x);
hold on;
plot(cos(t),sin(t),'-b','Linewidth',2);
axis equal;
title('BFGS x0 = [0,0.9999]');

subplot(1,2,2);
r.contour([-1.5 1.5],[-1.5 1.5], 80, @(x) x);
hold on;
plot(cos(t),sin(t),'-b','Linewidth',2);
axis equal;
title('BFGS x0 = [0,0.8]');

%x0 = r.guess(int32(1));
x0 = [0; 0.999993944545];
[xs,converged] = minimization_method.minimize( x0 );
subplot(1,2,1);
minimization_method.plotIter();
xs
x0 = [0; 0.8];
[xs,converged] = minimization_method.minimize( x0 );
subplot(1,2,2);
minimization_method.plotIter();
xs
