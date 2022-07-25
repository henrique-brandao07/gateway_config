# Gateway Kerlink Wirnet Station.
## LEDs management
Os leds são ativados durante um minuto após pressionar o botão de teste.
|Função  |Cor    |Modo     | Detalhes
|--------|-------|---------|--|
|Power   |Verde  |Contínuo |  |
|GSM_1   |Verde  |Contínuo |Gerenciado por plataforma  |
|GSM_2   |Verde  |Contínuo |Gerenciado por plataforma  |
|WAN     |Verde  |         |É para uso em aplicativos. Normalmente, este LED pode estar LIGADO quando o link WAN está ativo.  |
|MODEM_1 |Verde  |         |
|MODEM_2 |Verde  |         |


**GSM Status**
- 00b: erro
- 01b: sem rede
- 10b: RSSI < 17
- 11b: RSSI > 18

## Acesso
### Acesso SSH

Conecte o PC por cabo Ethernet à fonte de alimentação PoE e configure o IP do PC para 192.168.4.150.

SSH: 192.168.4.155 porta 22
* **Firmware version 2.x:**
Username: ```root```
Password:```root```
* **Firmware v3.1:**
Username: ```root```
Password: ```pdmk-0```seguido pelos últimos 7 caracteres do número de série do gateway em letras minúsculas. 
Ex: pdmk-080e0000.
* **Firmware v3.2:**
Username: root
Password: ```pdmk-0``` seguido pelos últimos 7 caracteres do número de série do gateway em letras maiúsculas. 
Ex: pdmk-080E0000.


## Gerenciamento de modem 3G/GPRS
### Conexão automática de rede sem Wanesy (KNONE)
A conexão GPRS é iniciada automaticamente na inicialização e monitorada pelo agente incorporado do Kerlink (reiniciada se a conexão GPRS/3G cair).

**Configuração de telecomunicações (APN)**

Defina sua APN em:  ```/etc/sysconfig/network```
```bash
# Selector operator APN
GPRSAPN=m2minternet
# Enter pin code if activated
GPRSPIN=
# Update /etc/resolv.conf to get dns facilities
GPRSDNS=yes
# PAP authentication
GPRSUSER=kerlink
GPRSPASSWORD=password
```
Você pode iniciar o serviço iniciando o script ```/etc/init.d/gprs start.```

**Configuração de auto conexão**
Ative e configure o recurso em: ```/knet/knetd.xml```
```bash
<!-- ############## local device configuration ############## -->
<LOCAL_DEV role="KNONE"/>
 
<!-- ############## connection parameters ############## -->
<!-- enable the autoconnect feature (YES/NO) -->
<CONNECT auto_connection="YES" />
<!-- frequency of connection monitoring -ping- (in seconds) -->
<CONNECT link_timeout="30"/>
<!-- DNS servers will be pinged if commented or deleted. Some operators can block the ping on there DNS servers so your server IP must be used to ping -->
<!-- CONNECT ip_link="8.8.8.8"/ -->
 
<!-- ############## default area for connection policy ############## -->
 
<AREA id="default">
<ACCESS_POINT bearer="gprs" />
</AREA>
```

O link Ethernet é tentado primeiro e o GPRS em segundo lugar. O link GPRS será definido como a rota de rede padrão somente se não houver acesso externo ethernet. Desconecte o cabo ethernet (dados) para garantir que a conexão GPRS seja válida.

**Aplique a configuração**
- Reinicie o sistema (comando: ```reboot```).
- Ou reinicie o agente knet (comando: ```/etc/rc.d/init.d/knet restart```).

### Teste de conexão com à internet
```bash
ping -c 5 8.8.8.8
```

## Verificando cominicação LoRa com o gateway
Use o seguinte comando no gateway para verificar se os dados estão sendo enviados e recebidos:
```bash
tcpdump -AUq port 1700
```
Os logs do Encaminhador de Pacote Comum estão localizados em:
```bash
tail -f /mnt/fsuser-1/lora/var/log/lora.log
```
