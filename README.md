# Dekompilert smittestopp

## Om prosjektet

Simula har utviklet en smittesporingsapp for Norge som ble rullet ut den 16. April 2020. Helt siden appen ble annonsert har det vært utrykket bekymringer fra utviklere som mente appen kunne ha personvernsproblemer. Disse har ikke blitt tilstrekkelig hørt. Det mest gjengående ønsket har vært et ønske om åpen kildekode, slik at uviklere selv kan se hvordan appen fungerer. Det er mange grunner til at dette er ønsket:

 * Appen ble utviklet på kort tid, noe som ofte medfører økt sjanse for tekniske problemer. Da de fleste sikkerhetshull er tekniske feil en angriper kan utnytte, impliserer kjapp utvikling høyere risiko for sikkerhetshull.
 * Simula er ikke et apputviklingshus. Det er ingen god oversikt over kompetansen til foretaket - det kan godt hende det er ansatt utviklere med bakgrunn i apputvikling, men vi vet ikke dette. Mangel på erfaring er også en kilde til sikkerhetshull, da det er mange triks en utvikler må kjenne til for å skrive kode som er trygg. Selv om en app fungerer bra, betyr ikke det at den er trygg.
   - Shortcut hjelper Simula, noe som mitigerer denne bekymringen: https://blog.shortcut.global/blog/shortcut-supporting-simula-to-create-an-app-for-the-norwegian-institute-for-public-health
   - Det er likevel usikkerhet rundt nøyaktiv hva shortcut har gjort
 * I Open source-miljøet er det ofte ønsket å vite nøyaktig hva slags kode man kjører på datamaskinen sin. Dette realiseres ofte i form av at programmer leveres som kildekode, som bygges på datamaskinen din når du skal installere det. Da menneskesporing er en veldig seriøs aktivitet, er det forståelige grunner til at en kan ønske å se kildekoden til applikasjonen som skal spore en.
   - Merk at det er ingen garanti for at det ikke er sneket inn ekstra kode når applikasjonen er kompilert - å levere ut kildekoden er også avhengig av at de som leser den har tillit til at det faktisk er denne koden simula bruker når de kompilerer appene for App store/Play store.


**Simula har ikke ønsket å åpne kildekoden, og har over tid tatt kritikk mindre seriøst.** I et intervju med dagens næringsliv den 14. April svarte Kyrre Lekve på et spørsmål om nødvendigheten til sentral lagring med "Ja, man må stole på kongen. Kongen har vedtatt dette i statsråd. Det ligger et grunnleggende tillitsforhold her, ja". At Simula peker til autoritet i stedet for å ta kritikk faller i veldig dårlig smak, og reduserer tillit. Merk at dette kan også ha skjedd pga. mangel på en sitatsjekk.

Grunnen til at dette prosjektet eksisterer er for å underbygge følgende budskap: **Dersom en amatør klarer å dekompilere og deobfuskere nok av applikasjonen til å forstå hvordan den fungerer på et par dager, er å lukke kildekoden til appen ubrukelig, da eksperter i andre lands etteretningstjenester antageligvis er ferdig med sitt arbeid allerede.**

Husk at å dele koden med andre land kommersielt øker risikoen for Nordmenn, da å bruke tid på å analysere appen vil kunne gi mer resultat for angriperen.

Mye av mistilliten hadde vært løst dersom Simula gikk for en løsning som lagret data lokalt på telenfonen. Simula har vært for grådige ved å ønske å spore bevegelsesmønsteret til innbyggere, og derfor ødelagt et ellers bra prosjekt. En hybrid-løsning der data lagres lokalt, og sentralt dersom brukere samtykker til det, kunne vært et kompromiss, men dette har aldri blitt lagt på bordet. 

**Simula har latt interessen for å forske på bevegelsesmønstre i befolkningen være i veien for ønsket om å kjappt spore smitte. Dette er en interessekonflikt**

Dette prosjektet er heller ikke det eneste forsøket på å dekompilere og deobfuskere appen. 

### Lenker
 
1. [https://www.dn.no/teknologi/koronaviruset/regjeringen/apper/it-sikkerhetsekspert-mener-den-norske-smitteappen-samler-unodvendig-og-utrolig-privat-informasjon/2-1-790895](https://www.dn.no/teknologi/koronaviruset/regjeringen/apper/it-sikkerhetsekspert-mener-den-norske-smitteappen-samler-unodvendig-og-utrolig-privat-informasjon/2-1-790895 (Betalingsmur))
2. [https://www.simula.no/news/digital-smittesporing-apen-kildekode](https://www.simula.no/news/digital-smittesporing-apen-kildekode)

## TL;DR

 * Originalt språk: Kotlin
   - Mesteparten av koden er nok det obfuskerte standardbibilioteket til Kotlin.
   - Selve korona-appen ligger praktisk nok i `no.simula.corona` - det er ikke engang moro :(
 * Dekompilert til: Java
 * Dekompilator: CFR
 * Lagring: Azure
   - Det ser ut som at de 100% bruker azure sitt api, uten noe spesielle endepunkter
   - Dette er positivt fordi Azure's standardapi er definitivt ganske solid.

## Hvordan komme igang

Dette prosjektet var ment for en unix-maskin, men det kan hende du kommer unna med WSL om du bruker Windows.

Følgende må være installert:

 * Java(7 eller nyere-ish. Det er programmene i `tools` som trenger det)
 * Make

Legg ditt eksemplar av apk-filen i mappen `apk`, og gi den navnet `base.apk`. Kjør deretter `make decompiled` i din favoritt-terminal, i roten av prosjektet. Det kan ta et par minutter å dekompilere hele appen.

Dersom du ønsker å lese ressurser, etc, kan du bruke `make extracted` for å ekstrahere ting fra appen.

## Hvordan bidra

Det er mye som kunne blitt gjort bedre. Først og fremst skal dette prosjektet eksistere som et bevis på at en amatør kan få tak i en tilnærming av kildekoden selv, dersom nok arbeid er gjort. Likevel er bidrag veldig velkomne. Følgende trenger arbeid:

 * Fiks diff-løsningen så den er mer robust
   - Generer en diff-fil per kodefil, og fjern timestamps
 * Deobfusker mer kildekode
 * Skrive writeup basert på koden!
 * kode-hygiene

Det er anbefalt å ha JD-Gui oppe i et vindu ved sidenav ved dekompilering, da det gjør det lettere å følge Xrefs i kodebasen. Jeg har testet å refaktorere med eclipse, men opplevde at eclipse og JD-gui ikke var enige i hvor ting var definert.

## Kontakt

Twitter: @petterroea
Mail: me (alfakrøll) petterroea.com

## Tekniske detaljer

### Aktiviteter

 * `no.simula.corona.ui.register.PhoneVerificationActivity`
 * `no.simula.corona.BootCompletedReceiver` **eksportert** 
 * `no.simula.corona.MainActivity`
 * `no.simula.corona.ui.onboarding.OnboardingActivity`
 * `no.simula.corona.ui.register.RegisterActivity`
 * `no.simula.corona.ConsentActivity`
 * `com.microsoft.identity.client.BrowserTabActivity` **eksportert**
 * `no.simula.corona.SplashActivity`
 * `com.microsoft.identity.common.internal.providers.oauth2.AuthorizationActivity`
 * `com.microsoft.identity.client.internal.controllers.BrokerActivity`
 * `com.google.android.gms.common.api.GoogleApiActivity`


### Tjenester

 * `androidx.room.MultiInstanceInvalidationService`
 * `no.nordicsemi.android.support.v18.scanner.ScannerService`
 * `no.simula.corona.DataCollectorService`

### Recievers

 * `no.nordicsemi.android.support.v18.scanner.PendingIntentReceiver` **eksportert**

### Providers

 * `androidx.lifecycle.ProcessLifecycleOwnerInitializer`

### AppCenter events

 * `User provisioned`
 * `Invalid provision response`
 * `Provisioned`
 * `Mark upload failed`
 * `LeAdvertise`
 * `Malformed version string`
 * `Confirmed consent`
 * `Denied consent`
 * `User failed provisioning`
 * `User provisioned`
 * `Start Delete Everything`
 * `Got null token`
 * `Get token error`
 * `Verify Phone Number`
 * `Start Acquire Token`
 * `Acquire Token Cancelled`
 * `Acquired token`
 * `Permission Response`

