import discord
import os
from flask import Flask
from threading import Thread

# --- 24時間稼働用の設定 (Flask) ---
app = Flask('')

@app.route('/')
def home():
    return "Bot is alive!"

def run():
    app.run(host='0.0.0.0', port=8080)

def keep_alive():
    t = Thread(target=run)
    t.start()

# --- Discord Botの本番設定 ---
# 権限（インテント）の設定
intents = discord.Intents.default()
intents.message_content = True # メッセージを読み取るための重要なスイッチ
client = discord.Client(intents=intents)

@client.event
async def on_ready():
    # ログインに成功するとPCやReplitの画面に表示されます
    print(f'成功！ログインしました: {client.user}')

@client.event
async def on_message(message):
    # 自分のメッセージには反応しないようにする
    if message.author == client.user:
        return

    # 「こんにちは」と送られた時の反応
    if message.content == 'こんにちは':
        await message.channel.send('こんにちは！正常に動いているよ。')

# 実行開始
if __name__ == "__main__":
    keep_alive() # 24時間化の準備
    # トークンを読み込んで起動
    # ※PCでやる場合は os.environ.get('TOKEN') を "あなたのトークン" に書き換えてもOK
    token = os.environ.get('TOKEN') 
    if token is None:
        print("エラー: TOKENが設定されていません。")
    else:
        client.run(token)
