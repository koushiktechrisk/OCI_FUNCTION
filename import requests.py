import requests
 
url = "https://g0701bedf5947b9-trptest2.adb.ap-hyderabad-1.oraclecloudapps.com/ords/trp_wksp_2/role/rolerep"
 
try:
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        # Process the data as needed
        print(data)
    else:
        print(f"Error: {response.status_code} - {response.text}")
except requests.RequestException as e:
    print(f"Error: {e}")