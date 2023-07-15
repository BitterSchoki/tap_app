import argparse
import json
import sys
import pandas as pd
from sklearn.preprocessing import StandardScaler


WINDOW_SIZE = 5

def smooth_data(array):
    columns = ['X_acc', 'Y_acc', 'Z_acc', 'X_gyro', 'Y_gyro', 'Z_gyro']
    data = pd.DataFrame(array, columns=columns)
    smoothed_data = data.copy()
    for column in columns:
        smoothed_data[column] = data[column].rolling(window=WINDOW_SIZE, min_periods=1, center=True).mean()

    return smoothed_data


def normalize_data(df):
    accelerometer_columns = ['X_acc', 'Y_acc', 'Z_acc']
    gyroscope_columns = ['X_gyro', 'Y_gyro', 'Z_gyro']


    # Extract the sensor data columns
    sensor_data = df

    # Normalize the accelerometer data
    accelerometer_data = sensor_data[accelerometer_columns]
    accelerometer_scaler = StandardScaler()
    normalized_accelerometer = pd.DataFrame(accelerometer_scaler.fit_transform(accelerometer_data), columns=accelerometer_columns)

    # Normalize the gyroscope data
    gyroscope_data = sensor_data[gyroscope_columns]
    gyroscope_scaler = StandardScaler()
    normalized_gyroscope = pd.DataFrame(gyroscope_scaler.fit_transform(gyroscope_data), columns=gyroscope_columns)


    # Combine the normalized sensor data with the non-normalized columns
    sensor_data = sensor_data.reset_index(drop=True)
    normalized_accelerometer = normalized_accelerometer.reset_index(drop=True)
    normalized_gyroscope = normalized_gyroscope.reset_index(drop=True)
    normalized_df = pd.concat([normalized_accelerometer, normalized_gyroscope], axis=1)

    return normalized_df



def run(command):

    if command["cmd"] == CMD_SMOOTH_NORMALIZE:
        acc = command["accelorometerData"]
        gyro = command["gyroscopeData"]
        merged = [a1 + a2 for a1, a2 in zip(acc, gyro)]
        output = normalize_data(smooth_data(merged))
        return {
            "output": output,
        }

    else:
        return {"error": "Unknown command."}


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--uuid")
    args = parser.parse_args()
    stream_start = f"`S`T`R`E`A`M`{args.uuid}`S`T`A`R`T`"
    stream_end = f"`S`T`R`E`A`M`{args.uuid}`E`N`D`"
    while True:
        cmd = input()
        cmd = json.loads(cmd)
        try:
            result = run(cmd)
        except Exception as e:
            result = {"exception": e.__str__()}
        result = json.dumps(result)
        print(stream_start + result + stream_end)