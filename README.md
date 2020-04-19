# Dekompilert smittestopp

## Viktig

Jeg har kommet såpass langt at jeg ikke lenger ser på det som hensiktsmessig å publisere endringene mine offentlig. En writeup vil komme snart, med mine funn. Se [writeup.md](writeup.md)

## Om prosjektet

Simula har utviklet en smittesporingsapp for Norge som ble rullet ut den 16. April 2020. Helt siden appen ble annonsert har det vært uttrykt bekymringer fra utviklere som mente appen kunne ha personvernsproblemer. Disse har ikke blitt tilstrekkelig hørt. Det mest gjengående ønsket har vært et ønske om åpen kildekode, slik at utviklere selv kan se hvordan appen fungerer. Det er mange grunner til at dette er ønsket:

 * Appen ble utviklet på kort tid, noe som ofte medfører økt sjanse for tekniske problemer. Da de fleste sikkerhetshull er tekniske feil en angriper kan utnytte, impliserer kjapp utvikling høyere risiko for sikkerhetshull.
 * Simula er ikke et apputviklingshus. Det er ingen god oversikt over kompetansen til foretaket - det kan godt hende det er ansatt utviklere med bakgrunn i apputvikling, men vi vet ikke dette. Mangel på erfaring er også en kilde til sikkerhetshull, da det er mange triks en utvikler må kjenne til for å skrive kode som er trygg. Selv om en app fungerer bra, betyr ikke det at den er trygg.
   - Shortcut hjelper Simula, noe som mitigerer denne bekymringen: https://blog.shortcut.global/blog/shortcut-supporting-simula-to-create-an-app-for-the-norwegian-institute-for-public-health
   - Det er likevel usikkerhet rundt nøyaktig hva shortcut har gjort
 * I Open source-miljøet er det ofte ønsket å vite nøyaktig hva slags kode man kjører på datamaskinen sin. Dette realiseres ofte i form av at programmer leveres som kildekode, som bygges på datamaskinen din når du skal installere det. Da menneskesporing er en veldig seriøs aktivitet, er det forståelige grunner til at en kan ønske å se kildekoden til applikasjonen som skal spore en.
   - Merk at det er ingen garanti for at det ikke er sneket inn ekstra kode når applikasjonen er kompilert - å levere ut kildekoden er også avhengig av at de som leser den har tillit til at det faktisk er denne koden simula bruker når de kompilerer appene for App store/Play store.

Grunnen til at dette prosjektet eksisterer er for å underbygge følgende budskap: **Dersom en amatør klarer å dekompilere og deobfuskere nok av applikasjonen til å forstå hvordan den fungerer på et par dager, er å lukke kildekoden til appen ubrukelig, da eksperter i andre lands etterretningstjenester antageligvis er ferdig med sitt arbeid allerede.**

Dette prosjektet er ikke det eneste forsøket på å undersøke appen uten kildekoden. Følgende er et par andre som ser på saken:

 * https://gist.github.com/krissrex/56a0d821c482cf24c52925b8ff496019
 * https://twitter.com/hallny/status/1250757826823229441
 * https://twitter.com/roysolberg/status/1250765597031481344
 * https://twitter.com/msandbu/status/1250900953160724481
 * https://github.com/djkaty/no.simula.smittestopp/
 * https://github.com/ninjaspl0it/smittestopp-pentest


### Lenker
 
1. [https://www.dn.no/teknologi/koronaviruset/regjeringen/apper/it-sikkerhetsekspert-mener-den-norske-smitteappen-samler-unodvendig-og-utrolig-privat-informasjon/2-1-790895](https://www.dn.no/teknologi/koronaviruset/regjeringen/apper/it-sikkerhetsekspert-mener-den-norske-smitteappen-samler-unodvendig-og-utrolig-privat-informasjon/2-1-790895 (Betalingsmur))
2. [https://www.simula.no/news/digital-smittesporing-apen-kildekode](https://www.simula.no/news/digital-smittesporing-apen-kildekode)

## TL;DR

 * Originalt språk: Kotlin
   - Mesteparten av koden er nok det obfuskerte standardbibilioteket til Kotlin.
   - Selve korona-appen ligger praktisk nok i `no.simula.corona` - det er ikke engang moro :(
 * Lagring: Azure
   - Det ser ut som at de 100% bruker azure sitt api, uten noe spesielle endepunkter
   - Dette er positivt fordi Azure's standardapi er definitivt ganske solid.
 * Burde jeg installere appen?
   - Antageligvis, med mindre du må bry deg om kildevern eller lignende.

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

