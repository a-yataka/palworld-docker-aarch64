# palworld docker aarch64
- aarch64上のdockerで Linux - SteamCMD を使ってパルワールドサーバーを動かす
- Oracle Cloud Infrastructure 上の無料インスタンスで動かすことを想定している
# TODO 
- multi stage build
    - 一つのステージですべての処理を行っている。使い分けや再ビルドを考慮した構成に直す
- volume permission
    - Savedディレクトリの権限がホストとコンテナ内で異なる
        - 一旦、`chmod -R 777 Saved` でもごまかせる
        - セーブデータの扱いも含めて要改善