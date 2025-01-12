// app id : algolia.app.id
// api key : algolia.api.key

const functions = require("firebase-functions");
const admin = require("firebase-admin");

const algoliasearch = require("algoliasearch");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { object } = require("firebase-functions/v1/storage");
const { topic } = require("firebase-functions/v1/pubsub");

// API KEY
const ALGOLIA_APP_ID = process.env.ALGOLIA_APP_ID;
const ALGOLIA_API_KEY = process.env.ALGOLIA_API_KEY;
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_API_KEY);

// recommend_subject 컬렉션을 algolia index에 업데이트
async function setRecommendSubjectsData() {
  initializeApp();
  const recordCollection = [];

  const index = client.initIndex("recommend_subjects");
  const firestore = admin.firestore();
  const firestoreCollection = await firestore.collection("recommend_subjects");

  try {
    const snapshot = await firestoreCollection.get();
    if (!!snapshot) {
      for (let i = 0; i < snapshot.docs.length; i++) {
        const record = {
          objectID: i + 1,
          subjectId: snapshot.docs[i].data().subjectId,
          topic: snapshot.docs[i].data().topic,
        };
        recordCollection.push(record);
      }

      await index
        .saveObjects(recordCollection, { autoGenerateObjectIDIfNotExist: true })
        .wait();
    }
  } catch (e) {
    console.log(e);
  }
}

// recommend_subject 컬렉션을 algolia index에 업데이트
async function setSubjectsData() {
  initializeApp();
  const recordCollection = [];

  const index = client.initIndex("subjects");
  const firestore = admin.firestore();
  const firestoreCollection = await firestore.collection("subjects");

  try {
    const snapshot = await firestoreCollection.get();
    if (!!snapshot) {
      snapshot.forEach((element) => {
        const record = {
          topic: element.data().topic,
          postsIds: element.data().postsIds,
        };
        recordCollection.push(record);
      });
      await index
        .saveObjects(recordCollection, { autoGenerateObjectIDIfNotExist: true })
        .wait();
    }
  } catch (e) {
    console.log(e);
  }
}
