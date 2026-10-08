/**
 * Create admin user + Firestore profile for CMU SBNU VMS (Production)
 * Usage: node create-admin.js
 * 
 * Requires: GOOGLE_APPLICATION_CREDENTIALS environment variable pointing to service account JSON
 */

const admin = require('firebase-admin');

const ADMIN_EMAIL = 'admin@gmail.com';
const ADMIN_PASSWORD = 'Root@123';

async function createAdmin() {
  console.log('☁️  Using Production Firebase (cmu-sbnu-vms)');
  
  if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
    console.error('❌ GOOGLE_APPLICATION_CREDENTIALS not set');
    console.error('   1. Go to Firebase Console > Project Settings > Service Accounts');
    console.error('   2. Click "Generate New Private Key"');
    console.error('   3. Set env var: $env:GOOGLE_APPLICATION_CREDENTIALS="path/to/key.json"');
    process.exit(1);
  }

  admin.initializeApp({
    credential: admin.credential.applicationDefault(),
  });

  const auth = admin.auth();
  const db = admin.firestore();
  const now = admin.firestore.FieldValue.serverTimestamp();

  try {
    // 1. Create or get Auth user
    let userRecord;
    try {
      userRecord = await auth.getUserByEmail(ADMIN_EMAIL);
      console.log(`✅ Auth user exists: ${userRecord.uid}`);
    } catch (e) {
      userRecord = await auth.createUser({
        email: ADMIN_EMAIL,
        password: ADMIN_PASSWORD,
        emailVerified: true,
        displayName: 'Admin User',
      });
      console.log(`✅ Created Auth user: ${userRecord.uid}`);
    }

    // 2. Set admin custom claims
    await auth.setCustomUserClaims(userRecord.uid, {
      role: 'admin',
      isAdmin: true,
    });
    console.log('✅ Set admin custom claims');

    // 3. Create/update Firestore user profile (users/{uid})
    const userRef = db.collection('users').doc(userRecord.uid);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      await userRef.set({
        uid: userRecord.uid,
        displayName: 'Admin User',
        email: ADMIN_EMAIL,
        role: 'admin',           // Used by SessionController for routing
        status: 'approved',      // Required: only 'approved' users access protected routes
        createdAt: now,
        updatedAt: now,
        revision: 1,
        schemaVersion: 1,
      });
      console.log('✅ Created Firestore user profile (users/{uid})');
    } else {
      await userRef.update({
        role: 'admin',
        status: 'approved',
        displayName: 'Admin User',
        updatedAt: now,
      });
      console.log('✅ Updated Firestore user profile');
    }

    // 4. Create memberDirectory entry (for directory listings)
    const dirRef = db.collection('memberDirectory').doc(userRecord.uid);
    const dirDoc = await dirRef.get();

    if (!dirDoc.exists) {
      await dirRef.set({
        uid: userRecord.uid,
        displayName: 'Admin User',
        directoryStatus: 'active',
        unitLabel: 'CMU SBNU',
        createdAt: now,
      });
      console.log('✅ Created memberDirectory entry');
    } else {
      await dirRef.update({
        displayName: 'Admin User',
        directoryStatus: 'active',
      });
      console.log('✅ Updated memberDirectory entry');
    }

    // 5. Verify
    const updatedAuth = await auth.getUser(userRecord.uid);
    const updatedUser = await userRef.get();
    const updatedDir = await dirRef.get();

    console.log('\n✅ Verification:');
    console.log(`   Custom claims: ${JSON.stringify(updatedAuth.customClaims)}`);
    console.log(`   users/{uid}: role=${updatedUser.data().role}, status=${updatedUser.data().status}`);
    console.log(`   memberDirectory/{uid}: directoryStatus=${updatedDir.data().directoryStatus}`);

    console.log('\n🎉 Admin account fully configured!');
    console.log(`   Email: ${ADMIN_EMAIL}`);
    console.log(`   Password: ${ADMIN_PASSWORD}`);
    console.log(`   UID: ${userRecord.uid}`);
    console.log('\n⚠️  User must sign out/in for custom claims to take effect');

  } catch (error) {
    console.error('❌ Error:', error.message);
    process.exit(1);
  }
}

createAdmin();