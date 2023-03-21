
 clc
clear all；
data = load('C:\Users\Arthas\Desktop\train.csv');
MAE=0;
MSE=0;
i=1;
r2=0;
while i<=50
    data = data(randperm(size(data,1)),:); 
    ind = round(0.9 * size(data,1)); 
    %data= data(randperm(length(data)));
    trainData = data(1:ind, 1:end); 
    testData = data(ind+1:end, 1:end);
     P_train = trainData(:,1:86);
     T_train = trainData(:,87:129);
     P_test = testData(:,1:86);
     T_test = testData(:,87:129);
     P_train = P_train';
     T_train = T_train';
     P_test =  P_test';
     T_test = T_test';
     [p_train , ps_train ] = mapminmax(P_train,0,1);
     p_test = mapminmax('apply',P_test,ps_train);
    [t_train , ps_output ] = mapminmax(T_train , 0,1);
    net = feedforwardnet([5],'trainbr');
    net.trainParam.epochs = 30;
    net.trainParam.goal = 0.0035;
    net.trainParam.mu = 0.008;
    net = train(net,p_train,t_train);
    t_sim = sim(net,p_test);
    T_sim = mapminmax('reverse',t_sim,ps_output);
    R2 = corrcoef(T_sim,T_test);
    R2 = R2(1,2)^ 2;
    mae = mean(abs(T_sim - T_test));
    mse = mean((abs((T_sim - T_test).^2)));
    MAE=(MAE+mae);
    MSE=(MSE+mse);
    r2=(R2+r2);
    i=i+1;
end
MAE=MAE/(i-1);
Mape=Mape/(i-1);
MSE=MSE/(i-1);
r2=r2/(i-1);
fprintf ('MAE=%d/', MAE);
fprintf ('MSE=%d/', MSE);
fprintf ('r2=%d/', r2);
