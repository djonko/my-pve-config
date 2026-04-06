Voici l'adaptation du tutoriel pour votre cas spécifique sur Fedora.
Le problème actuel est que votre Echo Dot est reconnue comme une source (Gateway), alors que vous voulez qu'elle agisse comme une sortie (A2DP Sink) pour votre PC.
## Étape 3 : Créer la règle de forçage PipeWire
Sur Fedora, nous allons créer un fichier de configuration utilisateur pour forcer le profil Bluetooth.

1. Ouvrez un terminal.
2. Créez le dossier de configuration (s'il n'existe pas) :

mkdir -p ~/.config/pipewire/pipewire.conf.d/

3. Créez un nouveau fichier de configuration :

nano ~/.config/pipewire/pipewire.conf.d/99-alexa-sink.conf

4. Collez le code suivant à l'intérieur. J'ai adapté l'adresse MAC (74:58:F3:9B:56:92) et le nom d'après vos logs :

monitor.bluez.rules = [
{
matches = [
{
## Correspond à votre Echo Dot-X67
device.name = "bluez_card.74_58_F3_9B_56_92"
}
]
actions = {
update-props = {
## Force le profil A2DP Sink (Lecture audio)
bluez5.auto-connect = [ a2dp_sink ]
bluez5.profile = "a2dp_sink"
}
}
}
]

(Appuyez sur Ctrl+O puis Entrée pour sauvegarder, et Ctrl+X pour quitter).

## Étape 4 : Redémarrer les services audio
Pour que Fedora prenne en compte la modification sans redémarrer l'ordinateur, lancez cette commande :

systemctl --user restart pipewire wireplumber

## Étape 5 : Vérification et Connexion

1. Déconnectez votre Echo Dot depuis vos paramètres Bluetooth Fedora.
2. Dites : "Alexa, connecte-toi à mon ordinateur".
3. Relancez votre commande de vérification :

pactl list cards | grep -A2 "Active Profile"

Le profil actif devrait maintenant afficher a2dp_sink au lieu de off ou audio-gateway.

## Si l'option "a2dp_sink" n'apparaît toujours pas :
Il est possible que le paquet des codecs Bluetooth soit manquant. Sur Fedora, assurez-vous d'avoir installé les dépendances nécessaires :

sudo dnf install pipewire-codec-aptx libldac

Souhaitez-vous que je vous aide à vérifier si le codec spécifique utilisé par Amazon est bien actif après ces manipulations ?

