// .env에서 변수를 불러올 수 없어 우선 임시로 실제 키를 입력했습니다.
// 환경변수 사용하는 코드 :
// const ALGOLIA_ID = process.env.ALGOLIA_APP_ID;
// const ALGOLIA_ADMIN_KEY = process.env.ALGOLIA_ADMIN_KEY;

const functions = require("firebase-functions");
const admin = require("firebase-admin");

const algoliasearch = require("algoliasearch");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const { object } = require("firebase-functions/v1/storage");
const { topic } = require("firebase-functions/v1/pubsub");

// API KEY
const ALGOLIA_APP_ID = "H464EGHSBZ";
const ALGOLIA_API_KEY = "66cc719f55dc615b4e37378adfe04ff8";
const client = algoliasearch(ALGOLIA_APP_ID, ALGOLIA_API_KEY);

// recommend_subject 컬렉션을 algolia index에 업데이트
async function setRecommendSubjectsData() {
  initializeApp();

  const index = client.initIndex("recommend_subjects");
  const firestore = admin.firestore();
  const firestoreCollection = await firestore.collection("recommend_subjects");

  try {
    const snapshot = await firestoreCollection.doc("recommend").get();
    if (!!snapshot) {
      console.log(snapshot.data());
      const record = {
        objectID: "recommend",
        todayIdx: snapshot.data().todayIdx,
        subjectId: snapshot.data().subjectId,
      };
      await index
        .saveObjects([record], { autoGenerateObjectIDIfNotExist: true })
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

// async function findSubjectInAlgolia(query) {
//   const index = client.initIndex("subjects");
//   try {
//     const result = index.search(query);
//     if (!!result) {
//       return result;
//     }
//     return [];
//   } catch (e) {
//     console.log(e);
//     return [];
//   }
// }
