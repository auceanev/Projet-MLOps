#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Dec 18 15:30:39 2024

@author: ines
"""
import http
import socketserver
from http.server import BaseHTTPRequestHandler

#Importing required packages.
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split, cross_val_score

DATA_PATH = './data/raw/winequality-red.csv'

def training():
    #Loading dataset
    wine = pd.read_csv(DATA_PATH)

    #Let's check how the data is distributed
    wine.head()

    #Information about the data columns
    wine.info()

    #Here we see that fixed acidity does not give any specification to classify the quality.
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'fixed acidity', data = wine)

    #Here we see that its quite a downing trend in the volatile acidity as we go higher the quality
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'volatile acidity', data = wine)

    #Composition of citric acid go higher as we go higher in the quality of the wine
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'citric acid', data = wine)

    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'residual sugar', data = wine)

    #Composition of chloride also go down as we go higher in the quality of the wine
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'chlorides', data = wine)

    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'free sulfur dioxide', data = wine)

    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'total sulfur dioxide', data = wine)

    #Sulphates level goes higher with the quality of wine
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'sulphates', data = wine)

    #Alcohol level also goes higher as te quality of wine increases
    fig = plt.figure(figsize = (10,6))
    sns.barplot(x = 'quality', y = 'alcohol', data = wine)

    #Making binary classificaion for the response variable.
    #Dividing wine as good and bad by giving the limit for the quality
    bins = (2, 6.5, 8)
    group_names = ['bad', 'good']
    wine['quality'] = pd.cut(wine['quality'], bins = bins, labels = group_names)

    #Now lets assign a labels to our quality variable
    label_quality = LabelEncoder()

    #Bad becomes 0 and good becomes 1
    wine['quality'] = label_quality.fit_transform(wine['quality'])

    wine['quality'].value_counts()

    sns.countplot(wine['quality'])

    #Now seperate the dataset as response variable and feature variabes
    X = wine.drop('quality', axis = 1)
    y = wine['quality']

    #Train and Test splitting of data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size = 0.2, random_state = 42)

    #Applying Standard scaling to get optimized result
    sc = StandardScaler()

    X_train = sc.fit_transform(X_train)
    X_test = sc.fit_transform(X_test)

    rfc = RandomForestClassifier(n_estimators=200)
    rfc.fit(X_train, y_train)
    pred_rfc = rfc.predict(X_test)

    #Let's see how our model performed
    print(classification_report(y_test, pred_rfc))

    #Now lets try to do some evaluation for random forest model using cross validation.
    rfc_eval = cross_val_score(estimator = rfc, X = X_train, y = y_train, cv = 10)
    rfc_eval.mean()


def run():
    PORT = 8000
    Handler = http.server.SimpleHTTPRequestHandler
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print("serving at port", PORT)
        httpd.serve_forever()


# Best practice when running a script
if __name__ == '__main__':
    run()

