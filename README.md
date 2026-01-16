# medicine_app

Generate schema for models: 
`flutter pub run build_runner build`

Run `dart run build_runner build --delete-conflicting-outputs` to generate the data model serialization/deserialization code.

Flutter version 3.32.4


// TODO: add / modify data in draft logs based on 
/// - when the medicine is first time created.  (done)
/// - when the medicine consume log is updated or reverted then we need to make changes into the draft logs (done)
/// - when the medicine is deleted then we need to remove the draft logs related to that medicine (done)
/// - when the medicine is modified ( schedule, dosage, time ) then we need to update the draft logs related to that medicine (done)

// TODO: reschedule in splash screen, workmanager, adding / modifying medicine, modify medicine consume log (done)

// TODO: when user first time open the app, read the draft logs and insert medicine consume logs which medicine was taken and then  (done in top_screen_view.dart)


// TODO: check if there is any recursive isSynced issue when updating the draft logs and medicine consume logs.
/// - when the medicine is marked as taken from the then it synced. 
/// - when the medicine is marked from draft logs then it synced.



Run to build app : 
`flutter clean && flutter pub get && flutter pub run flutter_launcher_icons:main `