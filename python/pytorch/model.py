import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms
from torchvision.datasets import MNIST
from torch.utils.data import DataLoader
from torch.utils.data.sampler import SubsetRandomSampler
from torch import optim
import numpy as np

class Model(nn.Module):

    def __init__(self):
        super().__init__()
        self.hidden = nn.Linear(784, 128)
        self.output = nn.Linear(128, 10)
    
    def forward(self, x):
        x = self.hidden(x)
        x = F.sigmoid(x)
        x = self.output(x)

        return x
    
model = Model()

_tasks = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.5], std=[0.5])
])

mnist = MNIST("data", download=True, train=True, transform =_tasks) 

split = int(0.8 * len(mnist))
index_list = list(range(len(mnist)))
train_idx, valid_idx = index_list[:split], index_list[split:]

tr_sampler = SubsetRandomSampler(train_idx)
val_sampler = SubsetRandomSampler(valid_idx)

trainloader = DataLoader(mnist, batch_size=1, sampler=tr_sampler)
validloader = DataLoader(mnist, batch_size=1, sampler=val_sampler)

loss_function = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=0.01, weight_decay = 1e-6, momentum = 0.9, nesterov = True)

for epoch in range(1, 11): ## run the model for 10 epochs
    train_loss, valid_loss = [], []
    ## training part
    model.train()
    for data, target in trainloader:
        optimizer.zero_grad()
        ## 1. forward propagation
        output = model(data)
        ## 2. loss calculation
        loss = loss_function(output, target)
        ## 3. backward propagation
        loss.backward()
        ## 4. weight optimization
        optimizer.step()
        train_loss.append(loss.item())
    ## evaluation part

    model.eval()
    for data, target in validloader:
        output = model(data)
        loss = loss_function(output, target)
        valid_loss.append(loss.item())

    print ("Epoch:", epoch, "Training Loss: ", np.mean(train_loss), "Valid Loss: ", np.mean(valid_loss))