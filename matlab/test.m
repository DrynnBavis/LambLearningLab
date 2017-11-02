% Clear so no residual values are stored
clear;
clc;
% Two hidden layer convolution neural network
% ========== INITIALIZATION ==========
csv_file = csvread('sampleHousing.csv', 1, 0);
input = csv_file(:, 1:3);
output = csv_file(:, 4);
learning_rate = 0.005;
iterations = 10000

% Layer 1-2 weights
% 3 nodes in this layer
% Initialize to random values
theta1 = rand(3, 4);

% Layer 2-3 weights
% 3 nodes in this layer
% Initialize to random values
theta2 = rand(3,4);

% Layer 3-4 weights
% 1 nodes in this layer
% Initialize to random values
theta3 = rand(1,4);

% ========== TRAINING ==========
for i=1:1:iterations
  % ========== FORWARD PROPOGATION ==========
  % ========== LAYER 1 (INPUT) ==========
  x = input;
  % Add bias unit to input
  bias_input = ones(size(x,1),1);
  % a1 -> Output of layer 1
  a1 = [bias_input x];


  % ========== LAYER 2 ==========
  % a2
  % rows are training examples (10) and each column is a node
  z2 = a1 * theta1';
  a2 = z2;
  bias_input = ones(size(a2,1),1);
  a2 = [bias_input a2];


  % ========== LAYER 3 ==========
  % a3
  % rows are training examples (10) and each column is a node (3)
  z3 = a2 * theta2';
  a3 = z3;
  bias_input = ones(size(a3,1),1);
  a3 = [bias_input a3];

  % ========== LAYER 4 (OUTPUT) ==========
  % a3
  % rows are training examples (10) and each column is a node (1)
  z4 = a3 * theta3';
  a4 = z4;
  if(i == 1)
    a4 = a4
  end
  y = output;


  % ========== BACKWARD PROPOGATION ==========
  % ========== CALCULATE DELTAS ==========
  % ========== LAYER 4 (OUTPUT) ==========
  % Error (10 x 1)
  delE_dela4 = a4 - output;
  % This is g'(z(4)) (10 x 1)
  dela4_delz4 = ones(size(a4,1),1);
  delE_delz4 = delE_dela4 .* dela4_delz4;
  delta4 = delE_delz4;

  % ========== LAYER 3 (HIDDEN) ==========
  delz4_dela3 = theta3(:, 2:end);
  % This is g'(z(3)) (10 x 3)
  dela3_delz3 = ones(10, 3);
  delE_delz3 = (delta4 * delz4_dela3) .* dela3_delz3;
  delta3 = delE_delz3;

  % ========== LAYER 2 (HIDDEN) ==========
  delz3_dela2 = theta2(:, 2:end);
  % This is g'(z(2)) (10 x 3)
  dela2_delz2 = ones(10, 3);
  delE_delz2 = (delta3 * delz3_dela2) .* dela2_delz2;
  delta2 = delE_delz2;

  % ========== CALCULATE CHANGES TO WEIGHTS ==========
  % ========== WEGHTS 3-4 (Theta3) ==========
  theta3_changes = delta4' * a3(:, 2:end) / size(delta4, 1);
  theta3_bias_changes = sum(delta4) / size(delta4, 1);
  theta3_changes = [theta3_bias_changes theta3_changes] * learning_rate;
  theta3 = theta3 .- theta3_changes;

  % ========== WEIGHTS 2-3 (Theta2) ==========
  theta2_changes = delta3' * a2(:, 2:end) / size(delta3, 1);
  theta2_bias_changes = sum(delta3, 1)';
  theta2_changes = [theta2_bias_changes theta2_changes] * learning_rate;
  theta2 = theta2 .- theta2_changes;

  % ========== WEIGHTS 1-2 (Theta1) ==========
  theta1_changes = delta2' * a1(:, 2:end) / size(delta2, 1);
  theta1_bias_changes = sum(delta2, 1)';
  theta1_changes = [theta1_bias_changes theta1_changes] * learning_rate;
  theta1 = theta1 .- theta1_changes;
  % printf("\n%d\n", i);
end

a4 = a4
y = output