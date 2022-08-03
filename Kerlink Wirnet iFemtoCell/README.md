# Gateway Kerlink Wirnet iFemtoCell 923.

## Acesso

### Acesso Web para atualização do Firmware
http://klk-wifc-xxxxxx.local/
Login with admin/pwd4admin
Obs.: xxxxxx é os últimos 6 dígitos do Board ID

#### Atualização
Na página Web acesse: ```Administration > Update > Update Gateway```

### Acesso SSH
**SSH:** klk-wifc-xxxxxx.local
```
login: root
pass: pdmk-xxxxxx
```
Obs.: xxxxxx é os últimos 6 dígitos do Board ID

#### Teste de conexão com à internet
```bash
ping -c 5 8.8.8.8
```

### Verificação de existência dos arquivos.
```bash
ls /etc/lorad/fevo/AU915-AU.json
ls /etc/default/lorad
ls /etc/default/lorafwd
```

## Configurações LoRa

### Configuração do arquivo lorad
```bash
sed -i 's/CONFIGURATION_FILE=""/CONFIGURATION_FILE="\/etc\/lorad\/fevo\/AU915-AU.json"/' /etc/default/lorad
sed -i 's/DISABLE_LORAD="yes"/DISABLE_LORAD="no"/' /etc/default/lorad
```

### Configuração do arquivo lorafwd
```bash
sed -i 's/DISABLE_LORAFWD="yes"/DISABLE_LORAFWD="no"/' /etc/default/lorafwd
```

### Configuração do arquivo lorafwd.toml
Definindo o host da Internet onde o gateway deve se conectar e portas de conexão Uplink e Downlink.
```bash
sed -i 's/#node = "localhost"/node = "3.19.12.121"/' /etc/lorafwd.toml
sed -i 's/#service.uplink = 20000/service.uplink = 1700/' /etc/lorafwd.toml
sed -i 's/#service.downlink = 20000/service.downlink = 1700/' /etc/lorafwd.toml
```

### Reiniciando o serviço LoRa 1.2.0 
```bash
/etc/init.d/lorad restart
/etc/init.d/lorafwd restart
```

### Verificando registro EUI 
EUI é usado para cadastro no ChirpStack.
```bash
grep EUI /tmp/board_info.json
```

### Verificando cominicação LoRa com o gateway
```bash
tail -f /var/log/lora.log
```

## Script para teste da conexão e reinicio automático quando estiver sem acesso a internet.

Crie e abra o arquivo check_no_connection_reboot.sh
```bash
cd /sbin
vi check_no_connection_reboot.sh 
```

Adicione as linhas no arquivo.
```bash
#!/bin/bash
# Set target host IP or hostname
TARGET_HOST='google.com.br'
count=$(ping -c 10 $TARGET_HOST | grep from* | wc -l)
if [ $count -eq 0 ]; then
    echo "$(date)" "Target host" $TARGET_HOST "unreachable, Rebooting!" >>/var/log/check_no_connection_reboot.log
    /sbin/shutdown -r 0
else
    echo "$(date) ===-> OK! " >>/var/log/check_no_connection_reboot.log
fi
```

### Agendamento do Script de teste da conexão.
```bash
chmod +x check_no_connection_reboot.sh
(crontab -l ; echo "*/30 * * * * nohup /sbin/check_no_connection_reboot.sh") | crontab -
reboot
```
