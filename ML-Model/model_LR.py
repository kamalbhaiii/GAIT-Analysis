import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import StandardScaler
from sklearn.pipeline import make_pipeline
from sklearn.metrics import classification_report
import joblib

# Load the dataset
data = pd.read_csv('ML-Model/activity_data.csv')

# Features and labels
X = data[['HeartRate', 'WalkingRate']]
y = data['Activity']

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a Logistic Regression model with a pipeline to scale the data
model = make_pipeline(StandardScaler(), LogisticRegression())

# Train the model
model.fit(X_train, y_train)

# Evaluate the model
y_pred = model.predict(X_test)
print(classification_report(y_test, y_pred))

# Save the trained model
joblib.dump(model, 'lr_activity_model.pkl')
