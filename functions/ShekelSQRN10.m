classdef ShekelSQRN10 < FunctionND
  %
  % The Shekel SQRN10 Function
  %
  %   based on a code of John Burkardt (http://people.sc.fsu.edu/~jburkardt/)
  %
  % Reference:
  %
  %   Richard Brent,
  %   Algorithms for Minimization with Derivatives,
  %   Dover, 2002,
  %   ISBN: 0-486-41998-3,
  %   LC: QA402.5.B74.
  %
  % Author:
  %   Enrico Bertolazzi
  %   Dipartimento di Ingegneria Indutriale
  %   Universita` degli Studi di Trento
  %   email: enrico.bertolazzi@unitn.it
  %

  properties (SetAccess = protected, Hidden = true)
    a
    c
  end

  methods
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function self = ShekelSQRN10()
      self@FunctionND(int32(4));
      self.exact_solutions = 4.0 * ones ( 4, 1 ); % one known solution
      self.guesses         = [ 1.0; 3.0; 5.0; 6.0];
      self.a = [ 4.0, 4.0, 4.0, 4.0; ...
                 1.0, 1.0, 1.0, 1.0; ...
                 8.0, 8.0, 8.0, 8.0; ...
                 6.0, 6.0, 6.0, 6.0; ...
                 3.0, 7.0, 3.0, 7.0; ...
                 2.0, 9.0, 2.0, 9.0; ...
                 5.0, 5.0, 3.0, 3.0; ...
                 8.0, 1.0, 8.0, 1.0; ...
                 6.0, 2.0, 6.0, 2.0; ...
                 7.0, 3.6, 7.0, 3.6 ].';

      self.c = [ 0.1, 0.2, 0.2, 0.4, 0.6, 0.6, 0.3, 0.7, 0.5, 0.5 ].';
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function f = eval(self,x)
      % evaluate function
      self.check_x(x);
      n = 4;
      m = 10;
      f = 0;
      for j = 1:m
        d = self.c(j) + sum ( ( x - self.a(:,j) ).^2 );
        f = f - 1/d;
      end
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function g = grad( self, x )
      % use analitic gradient
      %g  = self.FD_grad( x );
      %return
      self.check_x(x);
      n = 4;
      m = 10;
      g = zeros( 1, n );
      for j = 1:m
        d = self.c(j) + sum ( ( x - self.a(:,j) ).^2 );
        for k = 1:n
          d_k  = 2*( x(k) - self.a(k,j) );
          g(k) = g(k) + d_k / d^2;
        end
      end
    end
    %- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function h = hessian( self, x )
      % use analitic hessian
      self.check_x(x);
      h = zeros ( 4, 4 );
      n = 4;
      m = 10;
      for ii = 1 : n
        for jj = 1 : n
          for j = 1 : m
            d = self.c(j) + sum ( ( x(1:n) - self.a(1:n,j) ).^2 );
            h(ii,jj) = h(ii,jj) - 8.0 * ( x(ii) - self.a(ii,j) ) * ( x(jj) - self.a(jj,j) ) / d^3;
            if ( ii == jj )
              h(ii,jj) = h(ii,jj) + 2.0 / d^2;
            end
          end
        end
      end
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
