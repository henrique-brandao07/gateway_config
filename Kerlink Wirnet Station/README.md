# Gateway Kerlink Wirnet Station.
## LEDs management
Os LEDs são ativados durante um minuto após pressionar o botão de teste.
|Função  |Cor    |Modo     | Detalhes
|--------|-------|---------|--|
|Power   |Verde  |Contínuo |  |
|GSM_1   |Verde  |Contínuo |Gerenciado por plataforma  |
|GSM_2   |Verde  |Contínuo |Gerenciado por plataforma  |
|WAN     |Verde  |         |É para uso em aplicativos. Normalmente, este LED pode estar LIGADO quando o link WAN está ativo.  |
|MODEM_1 |Verde  |         |
|MODEM_2 |Verde  |         |


### **GSM Status**
|GSM_1|GSM_2|Status	
|-------|------|--------|
|0|0|erro
|0|1|sem rede
|1|0|RSSI < 17
|1|1| RSSI > 18

## Acesso
### Acesso SSH

Conecte o PC por cabo Ethernet à fonte de alimentação PoE e configure o IP do PC para 192.168.4.150.

SSH: **192.168.4.155** porta 22
Obs.: O endereço IP estático 192.168.4.155 é configurado se nenhuma concessão de DHCP puder ser obtida.

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
 # Bearers priority order
 BEARERS_PRIORITY="ppp0,eth0,eth1"
```
Você pode iniciar o serviço iniciando o script ```/etc/init.d/gprs start```

O campo BEARERS_PRIORITY é definido no script da *versão wirmaV2_wirgrid_v2.1*. Este campo define a ordem de prioridade das diferentes interfaces que podem usar uma rota padrão. No caso ```BEARERS_PRIORITY=“ppp0,eth0,eth1”```, ppp0 tem prioridade. Se ppp0 estiver desconectado, eth0 se tornará a rota padrão.
Visualizar ordem de prioridade: ```grep BEARER /etc/sysconfig/network```

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

**Nota:** *O link Ethernet é tentado primeiro e o GPRS em segundo lugar. O link GPRS será definido como a rota de rede padrão somente se não houver acesso externo ethernet. Desconecte o cabo ethernet (dados) para garantir que a conexão GPRS seja válida.*

**Aplique a configuração**
- Reinicie o sistema (comando: ```reboot```).
- Ou reinicie o agente knet (comando: ```/etc/rc.d/init.d/knet restart```).

### Teste de conexão com à internet
```bash
ping -c 5 8.8.8.8
```
## Endereço IP estático
Edite o arquivo de configuração de rede ```/etc/sysconfig/network```

Desabilite solicitações DHCP:
```bash
# claims dhcp request on eth0
ETHDHCP=no
```
Modifique a configuração Ethernet com os parâmetros desejados.
```bash
# if static addr is selected on eth0
ETHIPADDR=192.168.4.155
ETHNETMASK=255.255.255.0
ETHBROADCAST=192.168.4.255
ETHGATEWAY=192.168.4.1
 
# manual DNS server
DNSSERVER1=9.9.9.9
DNSSERVER2=208.67.222.222
```
Reinicie o script de rede ```/etc/init.d/network restart``` ou reinicie o Wirnet Station.

## Informações 
### Número de série do gateway
* **Firmware v3.1:** 
	```bash
	hostname | sed -e s/Wirnet_0/0x/
	```
* **Firmware v2.3.3 ou inferior:**
	```bash
	hostname | sed -e s/Wirgrid_0/0x/
	```
###  Endereço MAC
```bash
ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
```

## Comunicação LoRa com o gateway
Use o seguinte comando no gateway para verificar se os dados estão sendo enviados e recebidos:
```bash
tcpdump -AUq port 1700
```
Os logs do Encaminhador de Pacote Comum estão localizados em:
```bash
tail -f /mnt/fsuser-1/lora/var/log/lora.log
```
## Modo de recuperação
Para forçar o gateway a se reinstalar.
* Digite os seguintes comandos:
	```bash
	fw_setenv bootfail 100
	reboot
	```
* Manualmente: você deve redefinir o gateway 22 vezes.
	1.	Ligue o sistema.
	2.	Pressione e solte o botão de reinicialização.
	3.	Aguarde entre 4 e 10 segundos.

## Compatibilidade com dispositivos PoE.
A Estação Wirnet™ **não** é compatível com os seguintes dispositivos Power Over Ethernet:
- TP-Link TL-POE150S - injetor autônomo
- Cisco Catalyst 3850 - switch PoE
- Comutador TP-LINK TL-SF1008P -PoE
- NETGEAR FS108PEU - Comutador PoE
- POE-48I Laird Technologies IAS - injetor autônomo
