function carnation
% CARNATION Generate a 3D visualization of carnation flowers with sepals and stems.
% This code is authored by Zhaoxu Liu / slandarer 
% for the purpose of celebrating Mother's Day 2026.
% =========================================================================
% Zhaoxu Liu / slandarer (2026). carnation for Mother's Day 
% (https://www.mathworks.com/matlabcentral/fileexchange/183838-carnation-for-mother-s-day), 
% MATLAB Central File Exchange. Retrieved May 9, 2026.

% Create figure and axes / 创建图窗及坐标区域
fig = figure('Units','normalized', 'Position',[.3,.1,.4,.8],'Color',[244,234,225]./255);
axes('Parent',fig, 'NextPlot','add', 'DataAspectRatio',[1,1,1],...
    'View',[-64, 5.5], 'Position',[0,-.15,1,1], 'Color',[244,234,225]./255, ...
    'XColor','none', 'YColor','none', 'ZColor','none');
annotation("textbox", [.05, .8, .9, .2], "String", {"Happy"; "Mother's Day"}, ...
    'FontName','Segoe Script', 'FontSize',52, 'FontWeight','bold', 'EdgeColor','none', ...
    'HorizontalAlignment','center', 'VerticalAlignment','middle', 'Color',[97,40,20]./255);


xx = linspace(0, 1, 100);
tt = linspace(0, 1, 1e4);
[X, P] = meshgrid(xx, tt);
T1 = P*20*pi;

C1 = 1 - (1 - mod(3.6*T1/pi, 2)).^4./2;                               % Petal profile   / 花瓣形状
S1 = (sin(50*T1)/150 + sin(10*T1)/30).*min(1, max(0, (X - .85)/.1));  % Edge serration  / 边缘褶皱和锯齿     
Y1 = (- (X.*1.2 - .5).^5.*32 - 1)./15.*P;                             % Petal curvature / 花瓣弧度

% Petal shape and serration modeling + rotating the planar petal to tilt it
% 花瓣形状和锯齿塑造 + 转动平躺的花瓣令其倾斜
R1 = (C1 + S1).*(X.*sin(P) - Y1.*cos(P))./(P + .5);
H1 = (C1 + S1).*(X.*cos(P) + Y1.*sin(P));

% Convert radius to Cartesian coordinates / 将半径映射为X,Y坐标
X1 = R1.*cos(T1);
Y1 = R1.*sin(T1);

% Colormap for carnation petals / 康乃馨配色
CList1 = [208, 62, 23; 221,146,121; 229,201,202; 233,219,222; 237,223,225]./255;
CMat1 = zeros(1e4, 100, 3);
CMat1(:, :, 1) = repmat(interp1(linspace(0, 1, size(CList1, 1)), CList1(:, 1), linspace(0, 1, 100)), [1e4, 1]);
CMat1(:, :, 2) = repmat(interp1(linspace(0, 1, size(CList1, 1)), CList1(:, 2), linspace(0, 1, 100)), [1e4, 1]);
CMat1(:, :, 3) = repmat(interp1(linspace(0, 1, size(CList1, 1)), CList1(:, 3), linspace(0, 1, 100)), [1e4, 1]);
% Darken edges / 边缘的深色
for i = 1:1e4
    tNum = randi([98, 100]);
    CMat1(i, tNum:end, 1) = 212./255;
    CMat1(i, tNum:end, 2) =  87./255;
    CMat1(i, tNum:end, 3) = 113./255;
end

% Rotation matrices / 旋转矩阵
Rx = @(rx) [1, 0, 0; 0, cos(rx), -sin(rx); 0, sin(rx), cos(rx)];
Rz = @(yz) [cos(yz), - sin(yz), 0; sin(yz), cos(yz), 0; 0, 0, 1];
Rx1 = Rx(pi/6); Rz1 = Rz(0);

% Render flower / 绘制康乃馨
surface(X1, Y1, H1 + .3, 'CData',CMat1, 'EdgeAlpha',0.1, 'EdgeColor',[224,39,39]./255, 'FaceColor','interp')
[U1, V1, W1] = matRotate(X1, Y1, H1 + .3, Rx1);
surface(U1 + .7, V1 - .7, W1 - .6, 'CData',CMat1, 'EdgeAlpha',0.1, 'EdgeColor',[224,39,39]./255, 'FaceColor','interp')

% Following the same method as before, 
% the profile is designed with four serrated cycles to simulate the four sepals.
% 还是之前的方法，不过让轮廓有4个锯齿状周期来模拟四片花萼
% Sepals generation with 4-lobed pattern / 生成四片花萼（带4个锯齿状周期）
[X, T] = meshgrid(linspace(0, 1, 100), linspace(0, 1, 100).*2*pi);
P2 = T.*0 + pi/8;
C2 = .5 + (.5 - abs(mod(T, pi/2)/pi*2 - .5))*.4;
Y2 = (- (X.*1 - .5).^7.*128 - 1)./15 - .1;   
R2 = C2.*(X.*sin(P2) - Y2.*cos(P2));
H2 = C2.*(X.*cos(P2) + Y2.*sin(P2));
X2 = R2.*cos(T);
Y2 = R2.*sin(T);
% Rotate by 90 degrees around the z-axis 
% and reduce the size to render the four smaller sepals.
% 绕z轴旋转90度且减小其大小，绘制四片小花萼
% Smaller sepal layer / 绘制四片小花萼（第二层）
P3 = T.*0 + pi/10;
C3 = .3 + (.5 - abs(mod(T + pi/4, pi/2)/pi*2 - .5))*.7;
Y3 = (- (X.*.7 - .5).^7.*128 - 1)./15 - .1;
R3 = C3.*(X.*sin(P3) - Y3.*cos(P3));
H3 = C3.*(X.*cos(P3) + Y3.*sin(P3));
X3 = R3.*cos(T);
Y3 = R3.*sin(T);

% Colormap for sepals / 花托配色
CList2 = [178,173,113; 151,135, 73; 117,123, 50;  86, 89, 29;  75, 65, 17]./255;
CMat2 = zeros(100, 100, 3);
CMat2(:, :, 1) = repmat(interp1(linspace(0, 1, size(CList2, 1)), CList2(:, 1), linspace(0, 1, 100)), [100, 1]);
CMat2(:, :, 2) = repmat(interp1(linspace(0, 1, size(CList2, 1)), CList2(:, 2), linspace(0, 1, 100)), [100, 1]);
CMat2(:, :, 3) = repmat(interp1(linspace(0, 1, size(CList2, 1)), CList2(:, 3), linspace(0, 1, 100)), [100, 1]);

% Render sepals / 绘制花托
surf(X2, Y2, H2.*.8 + .12, 'CData',CMat2, 'EdgeAlpha',0.1, 'EdgeColor',CList2(end,:), 'FaceColor','interp')
surf(X3.*.93, Y3.*.92, H3.*.5 + .02, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')
[U2, V2, W2] = matRotate(X2, Y2, H2.*.8 + .12, Rx1);
[U3, V3, W3] = matRotate(X3.*.93, Y3.*.92, H3.*.5 + .02, Rx1);
surf(U2 + .7, V2 - .7, W2 - .6, 'CData',CMat2, 'EdgeAlpha',0.1, 'EdgeColor',CList2(end,:), 'FaceColor','interp')
surf(U3 + .7, V3 - .7, W3 - .6, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')

% A pulse function with two periods is applied 
% to the contour to simulate the leaves.
% 让轮廓有2个周期且是脉冲函数，来模拟叶片
P4 = T.*0 + pi/16;
C4 = - abs(mod(T, pi)/pi - .5) + .11;
C4(C4 < 0) = 0; C4 = C4.*10; C4(51:100, :) = C4(51:100, :).*.7;
Y4 = (- (X.*1.01 - .5).^7.*128 - 1)./15 - .03;
R4 = C4.*(X.*sin(P4) - Y4.*cos(P4));
H4 = C4.*(X.*cos(P4) + Y4.*sin(P4));
X4 = R4.*cos(T);
Y4 = R4.*sin(T);
surf(X4 - .1, Y4 + .05, H4 - 2.2, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')
[U4, V4, W4] = matRotate(X4 - .1, Y4 - .1, H4 + .1, Rz1);
[U4, V4, W4] = matRotate(U4, V4, W4, Rx1);
surf(U4 + .7, V4 - .7 + 1, W4 - .6 - 1.2, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')

P5 = T.*0 + pi/8;
C5 = - abs(mod(T + pi/6, pi)/pi - .5) + .11;
C5(C5 < 0) = 0; C5 = C5.*5;
Y5 = (- (X.*1.01 - .5).^7.*128 - 1)./15 - .1;
R5 = C5.*(X.*sin(P5) - Y5.*cos(P5));
H5 = C5.*(X.*cos(P5) + Y5.*sin(P5));
X5 = R5.*cos(T);
Y5 = R5.*sin(T);
surf(X5, Y5, H5 - .3, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')
[U5, V5, W5] = matRotate(X5, Y5, H5+.1, Rx1);
surf(U5 + .7, V5 - .7 + 1/4, W5 - .6 - 1.7/4, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')

% Render stems / 绘制花杆
P1_1 = [mean(X3(:).*.93), mean(Y3(:).*.92), mean(H3(:).*.5 + .02)];
P1_2 = [mean(X5(:)), mean(Y5(:)), mean(H5(:) - .3)];
P1_3 = [mean(X4(:) - .1), mean(Y4(:) + .05), mean(H4(:) - 2.2)];
P1_3 = (P1_3 - P1_2).*1.4 + P1_2;
[XX1, YY1, ZZ1] = cylinderXYZ(P1_1, P1_2, .05);
[XX2, YY2, ZZ2] = cylinderXYZ(P1_2, P1_3, .04);
surf(XX1, YY1, ZZ1, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')
surf(XX2, YY2, ZZ2, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')

P1_1 = [mean(U3(:) + .7), mean(V3(:) - .7), mean(W3(:) - .6)];
P1_2 = [mean(U5(:) + .7), mean(V5(:) - .7 + 1/4), mean(W5(:) - .6 - 1.7/4)];
P1_3 = [mean(U4(:) + .7), mean(V4(:) - .7 + 1), mean(W4(:) - .6 - 1.2)];
P1_3 = (P1_3 - P1_2).*2.4 + P1_2;
[XX1, YY1, ZZ1] = cylinderXYZ(P1_1, P1_2, .05);
[XX2, YY2, ZZ2] = cylinderXYZ(P1_2, P1_3, .04);
surf(XX1, YY1, ZZ1, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')
surf(XX2, YY2, ZZ2, 'FaceColor',[ 84, 85, 54]./255, 'EdgeAlpha',0.1, 'EdgeColor','k')

    % 在任意两点间构建圆柱
    function [XX, YY, ZZ] = cylinderXYZ(P1, P2, r)
        % CYLINDERXYZ Create a cylinder connecting two 3D points
        %   [XX, YY, ZZ] = cylinderXYZ(P1, P2, r) generates a cylinder
        %   of radius r between points P1 and P2.
        v = P2 - P1; l = norm(v);
        if l < eps, return; end
        [XX, YY, ZZ] = cylinder(r, 30); ZZ = ZZ * l;
        ddir = [0, 0, 1]; tdir = v / l;
        if dot(ddir, tdir) > 0.9999
            R = eye(3);
        elseif dot(ddir, tdir) < -0.9999
            R = [1, 0, 0; 0, -1, 0; 0, 0, -1];
        else
            av = cross(ddir, tdir); av = av / norm(av);
            R = axisRotate(av, acos(dot(ddir, tdir)));
        end
        for ii = 1:size(XX, 1)
            for jj = 1:size(XX, 2)
                p = R * [XX(ii, jj); YY(ii, jj); ZZ(ii, jj)];
                XX(ii, jj) = p(1) + P1(1);
                YY(ii, jj) = p(2) + P1(2);
                ZZ(ii, jj) = p(3) + P1(3);
            end
        end
    end

    % 通过矩阵旋转数据
    function [U, V, W] = matRotate(X, Y, Z, R)
        % MATROTATE Apply 3x3 rotation matrix to a set of 3D points
        %   [U,V,W] = matRotate(X,Y,Z,R) rotates points (X,Y,Z)
        %   using rotation matrix R.
        U = X; V = Y; W = Z;
        for ii = 1:numel(X)
            v = [X(ii); Y(ii); Z(ii)];
            n = R*v; U(ii) = n(1); V(ii) = n(2); W(ii) = n(3);
        end
    end
    % 根据轴-角参数生成旋转矩阵
    function R = axisRotate(axis, angle)
        % AXISROTATE Compute rotation matrix from axis-angle representation
        %   R = axisRotate(axis, angle) returns a 3x3 rotation matrix
        %   for rotating by angle (radians) around the given axis vector.
        %   Implementation based on Rodrigues' rotation formula.
        u = axis(1); v = axis(2); w = axis(3);
        c = cos(angle); s = sin(angle);
        R = [u^2 + (1-u^2)*c, u*v*(1-c) - w*s, u*w*(1-c) + v*s;
             u*v*(1-c) + w*s, v^2 + (1-v^2)*c, v*w*(1-c) - u*s;
             u*w*(1-c) - v*s, v*w*(1-c) + u*s, w^2 + (1-w^2)*c];
    end
end