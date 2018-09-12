classdef BiggsEXP6 < FunctionMap
  %
  %
  %
  % reference:
  %
  % @article{biggs1971minimization,
  % 	title={Minimization algorithms making use of non-quadratic properties of the objective function},
  % 	author={Biggs, MC},
  % 	journal={IMA Journal of Applied Mathematics},
  % 	volume={8},
  % 	number={3},
  % 	pages={315--327},
  % 	year={1971},
  % 	publisher={Oxford University Press}
  %     }
  %
  % see also in reference test N.9 (below)
  %
  % @article{More:1981,
  %   author  = {Mor{\'e}, Jorge J. and Garbow, Burton S. and Hillstrom, Kenneth E.},
  %   title   = {Testing Unconstrained Optimization Software},
  %   journal = {ACM Trans. Math. Softw.},
  %   volume  = {7},
  %   number  = {1},
  %   year    = {1981},
  %   pages   = {17--41},
  %   doi     = {10.1145/355934.355936}
  % }
  %
  % Author: Giammarco Valenti - University of Trento
  properties ( SetAccess = private , Hidden = true)
  	yi
  	ti
  end

  methods
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function self = BiggsEXP6(M)
      % BiggsEXP6( M )...............N = 6; M = M;
      self@FunctionMap(int32(6),int32(M)); % call superclass constructor
      self.exact_solutions = [];                 % no exacts solution provided
      self.guesses         = [ 1  2 1 1 1 1 ].'; % one guess
      i       = (1:self.M).';
      self.ti = double(0.1.*i);
      self.yi = exp( -self.ti ) - 5*exp( -10*self.ti ) + 3*exp( -4*self.ti );
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function F = evalMap(self,x)
      % evaluate the entries (not squared) of the function.
      X1 = x(1);
      X2 = x(2);
      X3 = x(3);
      X4 = x(4);
      X5 = x(5);
      X6 = x(6);

      t = self.ti;
      y = self.yi;

      F  =  X3 .* exp( -t .* X1 ) - X4 .* exp( -t .* X2 ) + X6 .* exp ( -t .* X5 ) - y; % vector of [ f_1(x) ... f_n(x) ] values.
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function J = jacobian( self, x )
      % use analytic jacobian
      self.check_x( x );
      X1 = x(1);
      X2 = x(2);
      X3 = x(3);
      X4 = x(4);
      X5 = x(5);
      X6 = x(6);

      t = self.ti;
      y = self.yi;

      J  = [(-1).*exp(1).^((-1).*t.*X1).*t.*X3,exp(1).^((-1).*t.*X2).*t.*X4, ...
                  exp(1).^((-1).*t.*X1),(-1).*exp(1).^((-1).*t.*X2),(-1).*exp(1).^(( ...
                            -1).*t.*X5).*t.*X6,exp(1).^((-1).*t.*X5)]; % generated by Wolfram Mathematica
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function T = tensor( self, x )
      self.check_x( x );
      X1 = x(1);
      X2 = x(2);
      X3 = x(3);
      X4 = x(4);
      X5 = x(5);
      X6 = x(6);

      t = self.ti;
      y = self.yi;
      % Create the n-matrices of T

      zeri = zeros(size(t));
      % Code generated by wolfram mathematica

      T1 = [exp(1).^((-1).*t.*X1).*t.^2.*X3,zeri,(-1).*exp(1).^((-1).*t.*X1).*t,zeri,zeri,zeri];

      T2 = [zeri,(-1).*exp(1).^((-1).*t.*X2).*t.^2.*X4,zeri,exp(1).^((-1).*t.*X2).*t,zeri,zeri];

      T3 = [(-1).*exp(1).^((-1).*t.*X1).*t,zeri,zeri,zeri,zeri,zeri];

      T4 = [zeri,exp(1).^((-1).*t.*X2).*t,zeri,zeri,zeri,zeri];

      T5 = [zeri,zeri,zeri,zeri,exp(1).^((-1).*t.*X5).*t.^2.*X6,(-1).*exp(1).^((-1).*t.*X5).*t];

      T6 = [zeri,zeri,zeri,zeri,(-1).*exp(1).^((-1).*t.*X5).*t,zeri];

      % Concatenate the n-matrices of T
      % Dimensions = MxNxN
      T = cat(3,T1,T2,T3,T4,T5,T6);
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function [f,g] = eval_FG( self, x )
      f = self.eval(x);
      g = self.grad(x);
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function [f,g,H] = eval_FGH( self, x )
      f = self.eval(x);
      g = self.grad(x);
      H = self.hessian(x);
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  end
end

%  #######################################################
%  #  _______   __  _____ ______ _______ _ ____   _____  #
%  #         \ |  |   ___|   ___|__   __| |    \ |       #
%  #          \|  |  __| |  __|    | |  | |     \|       #
%  #       |\     | |____| |       | |  | |   |\         #
%  #  _____| \____| _____|_|       |_|  |_|___| \______  #
%  #                                                     #
%  #######################################################
