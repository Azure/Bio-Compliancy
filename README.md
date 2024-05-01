# BIO Compliance Initiative Template

> As this project is specific for the Dutch government the rest of this article will be in Dutch.

Dit project omvat een Initiative Policy Template, welke ingeladen kan worden in Microsoft Azure. In combinatie met Defender for Cloud kan men auditen of resources in een Azure omgeving voldoen aan de BIO (Baseline informatiebeveiliging Overheid).

De BIO is het basisnormenkader voor informatiebeveiliging binnen alle overheidslagen. De BIO is van toepassing voor de volgende bestuursorganen:

- Rijksdienst
- Provincies
- Waterschappen
- Gemeentes

Dit template is het startpunt om BIO-compliant te worden in een Microsoft cloud omgeving. De template kan worden aangepast aan de eisen en wensen van een specifieke organisatie. De template omvat uitsluitend technische controls. Procesmatige controls dienen binnen de organisatie ingevoerd te worden om tot een volledig dekkende BIO compliancy te komen.

Deze template is gebaseerd op BIO Thema-uitwerking Clouddiensten versie 2.2.
Meer informatie hierover vind je op: [CIP overheid Cloud thema](https://cip-overheid.nl/productcategorieen-en-workshops/producten?product=Clouddiensten).

Voor de leesbaarheid en technische implementatie zijn de titels van de controls in deze template herschreven. Voor een volledige beschrijving van deze controls wordt verwezen naar de bovenstaande link op de website van het CIP Overheid.

![alt text](./media/BIO-compliancy-example.png?raw=true "BIO compliancy example")

## Bijdragen

Dit project verwelkomt bijdragen en suggesties. Voor de meeste bijdragen moet je akkoord gaan met een Licentieovereenkomst voor Donateurs (CLA) waarin wordt verklaard dat je het recht hebt om ons het recht te geven om je bijdrage te gebruiken en dat je dat ook daadwerkelijk doet. Ga voor meer informatie naar [https://cla.opensource.microsoft.com](https://cla.opensource.microsoft.com).

Wanneer je een pull-verzoek indient, zal een CLA-bot automatisch bepalen of je een CLA moet verstrekken en hoe je het pull-verzoek op de juiste manier afhandelt (bijv. Statuscontrole, opmerking). Volg gewoon de instructies van de bot. Je hoeft dit slechts één keer te doen over alle repo's met behulp van onze CLA.

Dit project heeft de [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/) aangenomen. Zie voor meer informatie over de Code of Conduct de ['Veelgestelde Vragen'](https://opensource.microsoft.com/codeofconduct/faq/) of neem contact op met [opencode@microsoft.com](mailto:opencode@microsoft.com) met eventuele aanvullende vragen of opmerkingen.

## Implementeren op Azure

| Versie | Implementeer |
|---|---|
| 2.2.3 |[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](./docs/README.md) |

## Updates van policies definities

Het policy-initiatief houdt ook bij welke policies zijn verwijderd door hun parameters nog steeds op te nemen in het initiatief, maar met de aanduiding 'deprecated'. Hierdoor is het mogelijk om het policy-set bij te werken zonder dat de toewijzingen veranderen, waardoor er geen extra actie nodig is dan het implementeren van dit policy-initiatief op dezelfde managementgroep of abonnement waar het oude policy-initiatief ook was geïmplementeerd.

## Disclaimer

Deze template dient te worden gezien als hulpmiddel om BIO compliancy te bereiken. Onder geen enkele voorwaarde garandeert Microsoft dat deze template direct leidt tot een volledige BIO compliancy ten aanzien van resources in de Microsoft Azure omgeving.

## Handelsmerken

Dit project kan handelsmerken of logo's bevatten voor projecten, producten of diensten. Geautoriseerd gebruik van Microsoft handelsmerken of logo's zijn onderworpen aan en moeten [Handelsmerk- en merkrichtlijnen van Microsoft](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general) volgen. Het gebruik van handelsmerken of logo's van Microsoft in gewijzigde versies van dit project mag geen verwarring veroorzaken of sponsoring door Microsoft impliceren. Elk gebruik van handelsmerken of logo's van derden is onderworpen aan het beleid van die derden.
