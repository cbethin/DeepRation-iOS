# DeepRation-iOS
Mobile Journaling application that will connect to DeepRation mental health analytics platform. App stores journaling entries securely in MongoDB database.

Connects to REST API written in Node.js running as Google Cloud Functions on charlesbethin.com. The cloud functions implement the following functionalities:

charlesbethin.com/updateJournalEntry:
- inputs(uid, entry)
- outputs(success/failure)

charlesbethin.com/getJournalEntries:
- inputs(uid, limit) : limit is the max number of entries to retreive
- outputs(array of journal entries)

charlesbethin.com/signinUser:
- inputs(idToken) : idToken is unique token from Firebase authentication used to sign user into system
- output(uid) : uid of user retrieved from firebase system
