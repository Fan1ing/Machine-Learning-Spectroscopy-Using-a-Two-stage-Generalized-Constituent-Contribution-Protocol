 clc
clear all；
data = load('C:\Users\Arthas\Desktop\train.csv');%Training data
data1 = load('C:\Users\Arthas\Desktop\test.csv');%test data
MAE=0;
MSE=0;
Mape=0;
i=1;
r=0;
T_sim1 =0;
while i<=1  %The value predicted at one time can also be the average value of multiple predictions.
     P_train = data(:,1:151);
     T_train = data(:,152:end);
     P_test = data1(:,1:151);
     T_test = data1(:,152:end);
     P_train = P_train'
     T_train = T_train'
     P_test =  P_test'
     T_test = T_test'
     [p_train , ps_train ] = mapminmax(P_train,0,1);
     p_test = mapminmax('apply',P_test,ps_train);
    [t_train , ps_output ] = mapminmax(T_train , 0,1);
    net = feedforwardnet([6],'trainbr');
    net.trainParam.epochs = 30;
    net.trainParam.goal = 0.008;
    net.trainParam.mu = 0.008;
    net = train(net,p_train,t_train);
    t_sim = sim(net,p_test);
    T_sim = mapminmax('reverse',t_sim,ps_output);
    R2 = corrcoef(T_sim,T_test);
    R2 = R2(1,2)^ 2;
    mae = mean(abs(T_sim - T_test));
    mse = mean((abs((T_sim - T_test).^2)));
    mape = mean(abs((T_sim - T_test)./T_test));
    T_sim1= T_sim1+T_sim;
    MAE=(MAE+mae);
    MSE=(MSE+mse);
    Mape=(Mape+mape);
    r2=(R2+r2);
    i=i+1;
end
T_sim1=T_sim1/(i-1);
MAE=MAE/(i-1);
MSE=MSE/(i-1);
r2=r2/(i-1);
Mape=Mape/(i-1);
fprintf ('MAE=%d/', MAE);
fprintf ('MSE=%d/', MSE);
fprintf ('Mape=%d/', Mape);
fprintf ('r2=%d/', r2);
