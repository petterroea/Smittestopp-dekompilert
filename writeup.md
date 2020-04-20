# Writeup

Versjon: 1 (20.04.2020). Se "History"-knappen på github for å se revisjoner.

## Om

Denne writeupen er basert på (antageligvis) versjon 1.0.2. Følgende er sjekksummer:

Md5:
```
8f819e9952796d2be342aa39b4fb2e95  apk/base.apk
```

Sha256:
```
c46762392fa4c73a0bc6df318e6cd072f6bbeaa011d12dce2981216574a79b8d  apk/base.apk
```

## Disclaimer

Ingen nye sikkerhetshull blir offentliggjort her. Alle foreslåtte risikoer og angrep er spekulasjon basert på eksisterende, kjente sikkerhetshull.

Hverken simula eller FHI har annonsert kanaler for å rapportere inn sikkerhetshull eller bugs. I situasjoner som dette brukes ofte [Responsible disclosure](https://en.wikipedia.org/wiki/Responsible_disclosure) i sikkerhetsindustrien. Det vil si, personen som finner sikkerhetshull gir produsenten rimelig tid til å fikse problemet før sikkerhetshullet blir offentliggjort. Det er derfor ønsket at FHI/simula annonserer en konkret kanal å bruke for å rapportere problemer.

## Om forfatteren

Forfatteren er en amatør som holder på med reversering av programvare på fritiden. Hensikten er å bevise at å lukke kildekoden er irrelevant, da selv amatører kan dekompilere Android-versjonen av appen, og gjøre den lesbar på et par dager(3, i dette tilfellet).

Forfatteren har lite erfaring med Android.

## Andre prosjekter

Det finnes andre prosjekter som ser på appen. Noen av disse har kommet lenger enn dette prosjektet:

 * https://gist.github.com/krissrex/56a0d821c482cf24c52925b8ff496019
 * https://twitter.com/hallny/status/1250757826823229441
 * https://twitter.com/roysolberg/status/1250765597031481344
 * https://twitter.com/msandbu/status/1250900953160724481
 * https://github.com/djkaty/no.simula.smittestopp/
 * https://github.com/ninjaspl0it/smittestopp-pentest


iOS-versjonen av appen er det ingen kjente forsøk på å dekompilere, antageligvis da de fleste som ser på dette er late og tar _the path of least resistance_. Dette er enten bra eller dårlig for iOS.

## Fremgangsmåte

Ved å dekompilere med en moderne dekompilator blir de fleste funksjonene, selv de som er optimalisert godt, dekompilert med bare små problemer. Fordi appen er skrevet i Kotlin, lekkes mange typenavn pga innebygde `null`-sjekker injisert av kompilatoren. 

APIer som er brukt finnes enkelt ved å søke på github etter strenger funnet i kodefiler. Fordi et API skal brukes av et annet menneske for å utvikle programvare, har de ofte god feilhåndtering. Dette fører til at det er mange feilmeldinger i koden som kan brukes for å identifisere filene. 

Ved hjelp av heuristikkene ovenfor, samt en mageføelse, er det mulig å rekonstruere navn på mesteparten av kodebasen. 

## Funn

### Kodestruktur

 * Mye av appen har beholdt sine originale klassenavn
   - Dette har antageligvis skjedd fordi appen eksponerer mange aktiviteter og tjenester til Android.
   - Mesteparten av appen(og mitt deobfuskeringsarbeid) er bibilioteker som har blit kompilert inn i appen.
 * Det er lagt igjen masse logging i appen, noe som gjør det lett å vite hva du ser på. Mesteparten av de interessante metodene avslører seg selv ved hjelp av logging.

### Kommunikasjon med skyen

Skyløsningen bruker bare standardløsninger fra Microsoft: Azure IotHub og AppCenter analytics. Analytics brukes for å logge bl.a feil, men det logges også om du ikke gir appen tillatelser eller ikke.

Se https://twitter.com/msandbu/status/1250900953160724481 for en bedre analyse.

### Batteribruk på eldre versjoner av android

Dersom Android-versjonen er mindre enn 26(Oreo), bruker [AlarmManager](https://developer.android.com/reference/android/app/AlarmManager#set(int,%20long,%20android.app.PendingIntent)) for å starte sporingen 10 sekunder senere enn vanlig. Dette _kan_ være en kilde til mye batteribruk(hyppig oppdatering), men jeg har ikke funnet et sted hvor denne timeren fornyes, så det virker mer som en bugfix for noe som at appen starter før bluetooth/gps er tilgjengelig.

## Tanker

Smittestopp viser et ærlig forsøk på en ansvarlig utviklet app, gitt kravene satt av Simula. Først og fremst vil jeg peke ut den kraftige bruken av APIer fra reputable aktører som Nordic Semiconductor og Microsoft. Å ikke lage hjemmesnekra løsninger er er veldig lovende tegn - se på Australia, som prøvde seg på hjemmesnekra anonymisering av gps-koordinater: https://twitter.com/xssfox/status/1251116087116042241

Det kan argumenteres om at appen i seg selv er hjemmesnekra - det finnes løsninger foretrukket av sikkerhetseksperter som blir tatt i bruk av andre land. Dette er dog ikke tilfellet fra synspunktet til Simula, som ønsker ekstra funksjonalitet i den Norske appen. Det er en fordel å kunne forske på bevegelsesmønstre, da dette er en veldig unik situasjon med mye vi kan lære om menneskelig oppførsel ved introduksjon av forskjellige tiltak mot smitte.

Appen i seg selv ser ikke ut til å være utviklet med obfuskering i tankene - det ser ut som at simula har gått for en middelvei hvor de verken ønsker å legge ut kildekoden, ei obfuskere den nok til at dette er et problem at koden ikke er lagt ut. Det tar bare et par dager ekstra for _alle_ å finne problemer.

Merk at vi har lite oversikt over hvordan skytjenesten er satt opp. Dette pirker også ekspertteamet på. En dårlig satt opp webløsning kan fort vise seg å lekke informasjon. Her kan vi ikke si noe bra eller dårlig, og det vil være ulovlig å forsøke å bryte seg inn på den for å finne ut av hvorvidt den er satt opp dårlig. 

En ting som kan sies er at dataene lagres i Irland, hos et Amerikansk selskap. Avhengig av hvor paranoid du er kan det dermed være rimelig å anta at denne dataen allerede er tilgjengelig for amerikanske etteretningsmyndigheter. NSA har gjort følgende før:

 * Kjøpt et kryptoselskap i hemmelighet og solgt utstyr med sikkerhetshull til allierte(Crypto AG)
 * Wiretappet internettlinja til mange land, inkludert allierte(Se snowden leaks, xkeyscore)
 * Instruert store selskaper som Microsoft, Apple, til å installere sikkerhetshull i produktene deres.

Det er derfor ikke umulig at NSA allerede har tilgang på produksjonsdatabasen til denne appen. Dette kan brukes for målrettet spionering av Norske borgere, skulle dette være av interesse for dem.

### DeviceID-problemet

En veldig godt likt løsning går ut på at en smittesporingsapp sender ut tilfeldige ord. Disse huskes av både sender, og alle som hører det. Det gjør at myndighetene kan si "alle som har hørt ordet eple må i karantene", uten at noen får vite hvem det var som sa ordet.

Smittestopp genererer ikke tilfeldige ord som sendes ut. Smittestopp får en "`deviceId`" fra skytjenesten, som den bruker for å unikt identifisere seg selv. Denne id'en annonseres til andre telefoner. Konsekvensen er at andre kan "kjenne deg igjen", og dette er utgangspunktet for å kunne spore noen. [Hallvard Nygård gikk ut med dette i VG](https://www.vg.no/nyheter/innenriks/i/y3dwae/). Han bruker som eksempel på risikoen med dette opplegget at du kan legge en telefon med en spesial-kodet sporingsapp i nærheten av huset til noen, og dermed vite om de er hjemme. 

## Anbefalninger

Du burde nok enda installere appen. Angrepsvektorene diskutert ovenfor krever alle at du fysisk er sammen med en angriper. Det er potensielt mulig at apper fra andre land kan få oppdateringer som saboterer for smittestopp, og dermed kan konvertere intetanende brukere til ondsinnede noder. Dette er dog lite sannsynlig, de eieren hadde mistet mye omdømme.

Da du uansett skal være hjemme, vil sporing også ha mindre nytteverdi. **En mulig mitigering av sporingsproblemet er å skru av appen når du er hjemme, og heller selektivt skru den på når du drar ut av huset**. Slik beholder du nytten, uten at kriminelle/etc kan sjekke om du er hjemme.

De fleste problemene med appen fører til dårlige resultater og redusert nytte. Dersom du stoler på myndighetene, er appen trygg for dagligdags bruk.

Selv om "konspirasjonsteorien" om at NSA har tilgang til produksjonsdatabasen til appen hadde vært sann, har de likevel lite interesse av deg som enkeltindivid. Dersom du derimot gjør ting du vet andre kan ha noe imot, eller holder på med kildevern, **burde du kanskje vurdere å ikke installere appen**. Det er mange gode artikler skrevet på hvordan å ha bra "opsec" når du vil unngå å bli sporet, og mange av tipsene gjør det vanskelig å bruke denne appen. Merk at du da burde ha god kontroll over hvem du har hatt kontakt med - **det hadde vært problematisk om du ikke installerer appen og ikke kan redegjøre for hvem du skal kontakte for å advare om smitte**

Antageligvis vil et par uker med bugfikser føre til en solid app - den har blitt utviklet i et hastverk. Flere features mangler, blant annet rapportering av kontakt med en som er bekreftet smittet. Simula har allerede lastet opp flere nye versjoner som jeg ikke har analysert, og svarer aktivt på negative anmeldelser på Play Store som klager på bugs. Dersom Simula åpner kildekoden, eller i hvertfall kunngjør en offisiell portal for bugreporting, kan enda flere problemer bli fikset, før folk med dårlige intensjoner finner de. 

Det er en kamp mot klokka, og utviklerne som skriker om problemene og prøver å få tak i Simula har som mål å stoppe motstanderne med dårlige intensjoner fra å få til et angrep.

