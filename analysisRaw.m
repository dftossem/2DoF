%% Plotting torque 1, torque 2, theta 1 and tetha 2 of same voltage value
% Raw data to degrees = (1 rev / (2^(encoder resolution) * Reduction))
 d101 = 360/(2^13*10);
 d501 = 360/(2^13*50);
% Number of test by voltage change
 number = 10;
 test_size = 901;
 t_calc = zeros(test_size);
%% Uncomment according to the data on Workspace
% Horizontal voltage test values 10:1
%  testVal = [8 870 880 9 10 12 14 16];
% Horizontal voltage test values 50:1
%  testVal = 48:1:120;
% Vertical voltage test values 10:1
%  testVal = 20:1:64;
% Vertical voltage test values 50:1
%  testVal = 56:1:198;

% First vector position
 p1 = '(1)';
% For 10:1 reduction link test motor torque
 fNameV101 = 'tq101_%s_%d';
% For 50:1 reduction link test motor torque
 fNameV501 = 'tq501_%s_%d';
% For 10:1 reduction link test motor angular position
 fNameP101 = 'pos101_%s_%d';
% For 50:1 reduction link test motor angular position
 fNameP501 = 'pos501_%s_%d';
% Miscelaneus variables
 sample_time = 0.01;    % Seconds
 simTime = 9;           % Seconds
 sStateVal = 600;       % Array position equal to six seconds
 m1 = 9.3309;           % Mass link 1 [kg]
 mc1 = 0.6716;          % Mass center link 1 [m]
 m2 = 2.97775;          % Mass link 2 [kg]
 mc2 = 0.349;           % Mass center link 2 [m]
 g = 9.63;              % Gravity in Bogotá [m/s^2]
 K_t = 0.498;           % Torque constant of motors [Nm/A]
% 0s to 9s time vector
 t = 0:sample_time:simTime;
%  Torque variable for sum
 auxTq = 0;
 auxTq101 = zeros(length(testVal));
 auxTq501 = zeros(length(testVal));
 volX = zeros(length(testVal));
% Filter values for torque data
 windowSize = 30;
 b = (1/windowSize)*ones(1,windowSize);
 a = 1;
%% Loop for all the voltage values
for k = 1:length(testVal)
    if testVal(k) < 10
        hTest = ['00' num2str(testVal(k))];
        figTitle = ['0.0' num2str(testVal(k))];        
    elseif testVal(k) < 100
        hTest = ['0' num2str(testVal(k))];
        figTitle = ['0.' num2str(testVal(k))];
    elseif testVal(k) == 100
        hTest = num2str(testVal(k));
        figTitle = [num2str(testVal(k)/100) '.00'];
    elseif testVal(k) > 100 && testVal(k) < 400
        hTest = num2str(testVal(k));
        figTitle = [num2str(testVal(k)/100) '0'];
    else
        hTest = ['00' num2str(testVal(k)/10)];
        figTitle = num2str(testVal(k)/10000);
    end
%     try
%         figure('units','normalized','outerposition',[0 0 1 1])
        figure
        volX(k) = testVal(k)/100;
        % Loops for the 10 tests
        subplot(2,3,5)
        for i = 1: number
            vT1 = sprintf(fNameV101, hTest, i);     % Joining formatName, voltage and test number
            pVectorT1 = [vT1 p1];                   % Selecting first position
            eval([vT1 '=' vT1 '-' pVectorT1 ';'])  % Intial condition: 0 N
            % Post-processing: filtering torque data
            auxT = eval(vT1);
            fT1 = filter(b, a, auxT);
            plot(t, fT1)
            hold on
        end
%         legend('1','2','3','4','5','6','7','8','9','10')
        title('\omega_2')
        ylabel('Velocity [rad/s]')
        xlabel('Time [s]')
        grid on
        grid minor
        subplot(2,3,2)
        for i = 1: number
            vT2 = sprintf(fNameV501, hTest, i);   % Joining formatName, voltage and test number
            pVectorT2 = [vT2 p1];                      % Selecting first position
            eval([vT2 '=' vT2 '-' pVectorT2 ';']);  % Intial condition: 0 N
            auxT = eval(vT2);
            fT2 = filter(b, a, auxT);
            plot(t, fT2)
            hold on
        end
%         legend('1','2','3','4','5','6','7','8','9','10')
        title('\omega_1')
        ylabel('Velocity [rad/s]')
        xlabel('Time [s]')
        grid on
        grid minor
        subplot(2,3,4)
        for i = 1: number
            vP2 = sprintf(fNameP101, hTest, i);   % Joining formatName, voltage and test number
            pVectorP2 = [vP2 p1];                      % Selecting first position
            eval([vP2 '=' vP2 '-' pVectorP2 ';']);  % Intial condition: 0 degrees
            plot(t, eval(vP2)*d101/(2*pi))
            hold on
        end
%         legend('1','2','3','4','5','6','7','8','9','10')
        title('\theta_2')
        ylabel('Angle [rad]')
        xlabel('Time [s]')
        grid on
        grid minor
        subplot(2,3,3)
        for i = 1: number
            vP1 = sprintf(fNameP501, hTest, i);   % Joining formatName, voltage and test number
            pVectorP1 = [vP1 p1];                      % Selecting first position
            eval([vP1 '=' vP1 '-' pVectorP1 ';']);  % Intial condition: 0 degrees
            t_calc = m2*g*sind(eval(vP1)*d501)/50;
            auxTq = auxTq + t_calc(600);
            plot(t, t_calc)
            hold on
        end
        title('\tau_{1c}')
        ylabel('Torque [N.m]')
        xlabel('Time [s]')
        grid on
        grid minor
        auxTq501(k) = mean(auxTq);
        auxTq = 0;
        subplot(2,3,1)
        for i = 1: number
            vP1 = sprintf(fNameP501, hTest, i);   % Joining formatName, voltage and test number
            pVectorP1 = [vP1 p1];                      % Selecting first position
            eval([vP1 '=' vP1 '-' pVectorP1 ';']);  % Intial condition: 0 degrees
            plot(t, eval(vP1)*d501/(2*pi))
            hold on
        end
%         legend('1','2','3','4','5','6','7','8','9','10')
        title('\theta_1')
        ylabel('Angle [rad]')
        xlabel('Time [s]')
        grid on
        grid minor
        subplot(2,3,6)
        for i = 1: number
            vP2 = sprintf(fNameP101, hTest, i);   % Joining formatName, voltage and test number
            pVectorP2 = [vP2 p1];                      % Selecting first position
            eval([vP2 '=' vP2 '-' pVectorP2 ';']);  % Intial condition: 0 degrees
            t_calc = m2*g*sind(eval(vP2)*d101)/10;
            auxTq = auxTq + t_calc(600);
            plot(t, t_calc)
            hold on
        end
        title('\tau_{2c}')
        ylabel('Torque [N.m]')
        xlabel('Time [s]')
        grid on
        grid minor
        auxTq101(k) = mean(auxTq);
        auxTq = 0;
        suptitle(['Input voltage ' figTitle '[V]'])
%     catch
%         warning(['No data for ' vT1]);
%         close
%     end
end
    pause
    cZeros = 0;
    for i = 1:length(auxTq101)
        if(auxTq101 == 0)
            cZeros = cZeros + 1;
        end
    end
    finalSize = length(auxTq101)-cZeros;
    tq101 = zeros(finalSize);
    tq501 = zeros(finalSize);
    v_X = zeros(finalSize);
    i = 1; j = 1;
    for k = 1:length(auxTq101)
        if(auxTq101(k) ~= 0)
            tq101(i) = auxTq101(k);
            v_X(i) = volX(k);
            i = i + 1;
        end
        if(auxTq501(k) ~= 0)
            tq501(j) = auxTq501(k);
            j = j + 1;
        end
    end
    subplot(2,1,1)
    plot(v_X, tq101, '*g')
    title('\tau_{10:1}')
    ylabel('Torque [N.m]')
    xlabel('Voltage [V]')
    grid on
    grid minor
    subplot(2,1,2)
    plot(v_X, tq501, '*g')
    title('\tau_{50:1}')
    ylabel('Torque [N.m]')
    xlabel('Voltage [V]')
    grid on
    grid minor
    suptitle('Torque behaviour by applied voltage')
