import pandas as pd
from flask import Flask, request, jsonify
from prometheus_flask_exporter import PrometheusMetrics
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
import mlflow.sklearn

DATA_PATH = './data/raw/winequality-red.csv'
# Charger les données
wine = pd.read_csv(DATA_PATH)

# Prétraitement des données
bins = (2, 6.5, 8)
group_names = ['bad', 'good']
wine['quality'] = pd.cut(wine['quality'], bins=bins, labels=group_names)
label_quality = LabelEncoder()
wine['quality'] = label_quality.fit_transform(wine['quality'])

X = wine.drop('quality', axis=1)
y = wine['quality']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

sc = StandardScaler()
X_train = sc.fit_transform(X_train)
X_test = sc.transform(X_test)

# Initialisation de MLflow
mlflow.set_experiment("Wine Quality Prediction")
with mlflow.start_run():
    model = RandomForestClassifier(n_estimators=200)
    model.fit(X_train, y_train)

    # Log du modèle
    mlflow.sklearn.log_model(model, "model")
    mlflow.log_param("n_estimators", 200)

# Création de l'application Flask
app = Flask(__name__)
metrics = PrometheusMetrics(app)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        features = data['features']
        features_scaled = sc.transform([features])
        prediction = model.predict(features_scaled)
        result = "good" if prediction[0] == 1 else "bad"
        return jsonify({'prediction': result})
    except Exception as e:
        return jsonify({'error': str(e)})

@app.route('/', methods=['GET'])
def hello():
    return "Hello World!"

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)