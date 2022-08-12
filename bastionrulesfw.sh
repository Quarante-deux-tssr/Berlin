iptables=/sbin/iptables

#Réinitialiser toutes les règles :
$iptables -t filter -F
$iptables -t filter -X

#Tout bloquer :
$iptables -t filter -P INPUT DROP
$iptables -t filter -P FORWARD DROP
$iptables -t filter -P OUTPUT DROP

#Autoriser localhost:
$iptables -t filter -A INPUT -i lo -j ACCEPT
$iptables -t filter -A OUTPUT -o lo -j ACCEPT

#Autoriser les connexions déjà établies :
$iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
$iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

#Ouverture port SSH 22 :
$iptables -t filter -A OUTPUT -p tcp --dport 22 -j ACCEPT
$iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT

#Ouverture port Agent Zabbix 10050:
$iptables -t filter -A OUTPUT -p tcp --dport 10050 -j ACCEPT
$iptables -t filter -A INPUT -p tcp --dport 10050 -j ACCEPT


#Supprimer les règles "ACCEPT all" :
$iptables -t filter -D INPUT 1
$iptables -t filter -D OUTPUT 1

