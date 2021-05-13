# README
ApplicationB

Utiliza:
- Ruby 3.0.1
- Rails 6.1.3.2

Gemas:
- faraday
- fedex
- rubocop
- sidekiq(debemos tener corriendo redis en nuestro servidor tambien)
- rspec-rails
- database_cleaner-active_record

Aclaraciones:
- Tenemos un Adapter para agregar otras empresas que nos pueden dar informacion de paquetes y es extensible
- En estos adapter tenemos el método get_homologated_tracking el cual nos devuelve a partir del code que es
    interno del ws de cada empresa el status que nosotros queremos(CREATED, ON_TRANSIT, DELIVERED, EXCEPTION) 
- En nuestro controller => StatusPackagesController tenemos por ahora el unico metodo GetTrackingInformationInFedex
    el cual va a consultar contra el ws de FEDEX, en caso de tener más empresas deberiamos tener uno por cada
    empresa y agregar un adapter como el que tenemos de fedex => FedexTrackingInformation.
- Para nuestra respuesta asincrónica lo que hicimos fue en el método GetTrackingInformationInFedex recibir
    el parámetro CallBackUrl el cual es a donde vamos a retornar el estado del paquete como respuesta asíncrona.
- Tenemos el modelo TrackingInformation el cual representa el registro que guardamos cada vez que obtenemos respuesta
    exitosa de fedex, para mantener un histórico de nuestros paquetes.
- Luego tenemos nuestra clase TrackingInformationFedexWorker el cual es el worker por el cual vamos a encolar los
    trabajos asincrónicos en nuestra cola de trabajos.
- Ante un error en el request a fedex, sidekiq ya se encarga de volver a repetir el método de consultar al ws de fedex
    automáticamente.


