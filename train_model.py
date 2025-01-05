import tensorflow as tf

# Path to your saved model (Keras .h5 model)
saved_model_path = r'C:\Users\Study\diabetes_trend_model.h5'

# Path where you want to save the converted .tflite model
tflite_model_path = r'C:\Users\Study\StudioProjects\healthcare_app\assets\models\diabetes_trend_model.tflite'

try:
    # Load the saved Keras model
    model = tf.keras.models.load_model(saved_model_path)
    print("Model loaded successfully.")

    # Convert the model to TensorFlow Lite format
    print("Starting model conversion...")

    # Initialize the TFLiteConverter from the Keras model
    converter = tf.lite.TFLiteConverter.from_keras_model(model)

    # Enable FlexOps for unsupported operations (necessary for more complex ops like TensorList)
    converter.allow_custom_ops = True  # Enables FlexOps, which supports more operations
    converter.experimental_enable_resource_variables = True  # Optional for resource variables

    # Remove optimizations to ensure model compatibility (try without optimizations)
    converter.optimizations = []

    # Optionally, add conversion flags to support only TFLite built-in ops
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS, tf.lite.OpsSet.SELECT_TF_OPS]

    # Convert the model
    tflite_model = converter.convert()
    print("Model conversion completed successfully.")

    # Save the TensorFlow Lite model
    with open(tflite_model_path, 'wb') as f:
        f.write(tflite_model)
    print(f"Model converted and saved as {tflite_model_path}")

except Exception as e:
    print(f"An error occurred: {e}")
