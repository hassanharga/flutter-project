const baseUrl = 'https://api.rateelapp.com/v1_dev';

final Map<String, Map<String, String>> endPoints = {
  'sendOTP': {
    'url': 'competition/postSMS',
    'type': 'POST',
  },
  'verifyOTP': {
    'url': 'competition/verifySMSTokenToRegisterUser',
    'type': 'POST',
  },
  'getTodayQuestion': {
    'url': 'competition/getTodayQuestion',
    'type': 'GET',
  },
  'postAnswer': {
    'url': 'competition/postAnswer',
    'type': 'POST',
  },
  'getContent': {
    'url': 'competition/getContent',
    'type': 'GET',
  },
  'getRecitersList': {
    'url': 'reciters',
    'type': 'GET',
  },
  'getRewayatsList': {
    'url': 'reciters',
    'type': 'GET',
  },
  'getReciterFolders': {
    'url': 'reciters/{reciterId}/folders',
    'type': 'GET',
  },
  'getFolderContent': {
    'url': 'reciters/{reciterId}/folders/{folderId}/content',
    'type': 'GET',
  },
  'getReciterSurahAyats': {
    'url': 'reciters/{reciterId}/surah/{surahNumber}/content',
    'type': 'GET',
  },
  'getPrayerTimes': {
    'url':
        'prayers/times?latitude={latitude}&longitude={longitude}&year={year}',
    'type': 'GET',
  },
  'searchForCity': {
    'url': 'prayers/search?city={city}',
    'type': 'GET',
  },
  'getTimeZone': {
    'url': 'prayers/timezone?latitude={latitude}&longitude={longitude}',
    'type': 'GET',
  },
  'getRecognitionPreSignedUrl': {
    'url': 'recognition/presignedUrl',
    'type': 'GET',
  },
  'recognizeRecording': {
    'url': 'recognition/{recordingId}',
    'type': 'GET',
  },
  'helpRecognition': {
    'url': 'recognition/help',
    'type': 'POST',
  },
  'userLogin': {
    'url': 'user/login',
    'type': 'POST',
  },
  'userVerify': {
    'url': 'user/verify',
    'type': 'POST',
  },
  'userUpdate': {
    'url': 'user/update',
    'type': 'PUT',
  },
  'getUserAction': {
    'url': 'user/action/{actionName}',
    'type': 'GET',
  },
  'addUserAction': {
    'url': 'user/action/{actionName}',
    'type': 'POST',
  },
};
