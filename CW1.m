raw_data = importdata('breast-cancer-wisconsin.data.txt'); %import given data
input_data = raw_data(:, 2:10); %seperate input data
output_data = raw_data(:, 11);  %seperate outputs

%_____________________________Start of Code for 3rd Hypothesis________________________________________________%
%---------To use test this code uncomment the following code------%
%{
%variables for training of neural network
benign_training_data = [];
malignant_training_data = [];
benign_target_training_data = [];
malignant_target_training_data = [];

%variables for testing of neurla network
testing_data = [];
target_testing_data = [];

benign_rows = 1;
malignant_rows = 1;

for n=1:699 %loop through all rows
    %get benign data
    if(benign_rows <= 229)
        if(output_data(n, 1) == 2) %check if it's benign
            benign_training_data = [benign_training_data; input_data(n, 7:9)]; %seperate training data
            benign_target_training_data = [benign_target_training_data; 0];
            benign_rows = benign_rows + 1; %need to increment benign_rows
        end
    elseif(output_data(n, 1) == 2) %else we need to seperate that data for testing purpose
            testing_data = [testing_data; input_data(n, 7:9)]; %seperate testing data
            target_testing_data = [target_testing_data; 0];                
    end
    
    %get malignant data
    if(malignant_rows <= 120)
        if(output_data(n, 1) == 4) %if it is malignant
            malignant_training_data = [malignant_training_data; input_data(n, 1:3)]; %seperate training data
            malignant_target_training_data = [malignant_target_training_data; 1];
            malignant_rows = malignant_rows+1; %need to increment malignant rows
        end
    elseif(output_data(n, 1) == 4) %else we need to seperate that data for testing purpose
            testing_data = [testing_data; input_data(n, 1:3)]; %seperate testing data
            target_testing_data = [target_testing_data; 1];
    end
end

%plot3(malignant_training_data(:, 1), malignant_training_data(:, 2), malignant_training_data(:, 3), '.r'); %pot malignant with red dots
%hold on; %plot next matrix on previous graph
%plot3(benign_training_data(:, 1), benign_training_data(:, 2), benign_training_data(:, 3), '.b'); %pot data of benign

%merge malignant training data and benign training data
training_data = [malignant_training_data; benign_training_data];
training_target = [malignant_target_training_data; benign_target_training_data];

%now need to train neural network function.....

net = newff(training_data',training_target',{20 20 20}, {'tansig' 'tansig' 'tansig' 'purelin'}, 'trainr', 'learngd', 'mse'); %make net object
net.trainParam.goal = 0.01; %set mean sqaure error
net.trainParam.epochs = 100;
net = train(net, training_data',training_target'); %train net

result = net(testing_data'); %testing net
result = round(result); %round off the values of result
accuracy = minus(target_testing_data', result); %subtract testing_target and result to find numbers of match during testing
match_index = sum(accuracy(:) == 0); %correct result
missmatch_index = sum(accuracy(:) == 1); %wrong result

%accracy_in_percentage 
accracy_percentage = match_index/350 * 100; %dividing matched results with total number of testing data rows
disp(accracy_percentage);
%}

%_____________________________End of Code for 3rd Hypothesis________________________________________________%

benign_rows = 1; 
malignant_rows = 1;

testing_data = []; %data for testing purposes
testing_target = []; %target for testing

training_data = []; %data on which we train neral network
target_data = []; %target data use during training

%seperation of data to train neural network on randomly chosen data
%{
training_data = input_data(1:349, :);   
testing_data = input_data(350:699, :);

target_data = output_data(1:349,1);
testing_target = output_data(350:699, 1);

%replace 2 with zero and 4 with 1
target_data(target_data(:, 1) == 2) = 0;
terget_data(target_data(:, 1) == 4) = 1;
testing_target(testing_target(:, 1) == 2) = 0;
testing_target(testing_target(:, 1) == 4) = 1;
%}

%________The folowing code is used for 1st, 2nd and 4th Hypothesis with minor changes__________%
 
%-------------------------------------------------------------------------------------------------------
%seperation of data for training neural network on 50% of data in which 17%
%contains malignant data and 33% contains benign  data....
%-----------------------------------------------------------------------------------------------------

for n=1:699 %loop through all rows
    
    %get benign data
    if(benign_rows <= 229) %when we collect 50% of data we need to stop here
        if(output_data(n, 1) == 2) %check if it's benign
            training_data = [training_data; input_data(n, :)]; %seperate training data
            target_data = [target_data; 0];
            benign_rows = benign_rows + 1; %need to increment benign_rows
        end
    elseif(output_data(n, 1) == 2) %else we need to seperate that data for testing purpose
            testing_data = [testing_data; input_data(n, :)]; %seperate testing data
            testing_target = [testing_target; 0];                
    end
    
    %get malignant data
    if(malignant_rows <= 120) %when we collect 50% of data we need to stop here  
        if(output_data(n, 1) == 4) %if it is malignant
            training_data = [training_data; input_data(n, :)]; %seperate training data
            target_data = [target_data; 1];
            malignant_rows = malignant_rows+1; %need to increment malignant rows
        end
    elseif(output_data(n, 1) == 4) %else we need to seperate that data for testing purpose
            testing_data = [testing_data; input_data(n, :)]; %seperate testing data
            testing_target = [testing_target; 1];
    end
end

%now need to train neural network function.....
net = newff(training_data',target_data',{20, 20, 20}, {'tansig' 'tansig' 'tansig'}  , 'trainr', 'learngd', 'mse'); %make net object
net.trainParam.goal = 0.01; %set mean sqaure error
net.trainParam.epochs = 100;
net = train(net, training_data',target_data'); %train net

result = net(testing_data'); %testing net
result = round(result); %round off the values of result
accuracy = minus(testing_target', result); %subtract testing_target and result to find numbers of match during testing
match_index = sum(accuracy(:) == 0); %correct result
missmatch_index = sum(accuracy(:) == 1); %wrong result

%accracy_in_percentage 
accracy_percentage = match_index/350 * 100; %dividing matched results with total number of testing data rows
disp(accracy_percentage);

%__________________End of code for 1st, 2nd and 4th Hypothesis________________________%