# restapi

This package gives access to Push Protocol (Push Nodes) APIs. Visit [Developer Docs](https://docs.push.org/developers) or [Push.org](https://push.org) to learn more.

## Initialization 
Set the environment and user's wallet (optional ) by calling the ```initPush``` function
  
  ```dart
await  initPush(
	wallet:  pushWallet,
	env:  ENV.staging,
);
```

## Channels


## Signer

For the user's PGP secret key encryption and decryption Singer capable of doing [eip-191]("https://eips.ethereum.org/EIPS/eip-191") signature. The Signer protocol defines an abstract signer that can be implemented to provide signing functionality. This protocol provides four methods: `getEip191Signature` and `getAddress`.

```dart
abstract  class  Signer {
	String?  privateKey;
	Future<String> getEip191Signature(String  message);
	Future<String> getEip712Signature(String  message);
	String  getAddress();

	/// Returns the signed-message.
	Future<String> signMessage(String  message);
}
```

  

### SignerPrivateKey

To begin using `Signer`, you can generate an instance of it using the `EthersSigner` struct and providing the Wallet from [Ethers Package](https://pub.dev/packages/ethers). The `EthersSigner` struct implements to the `Signer` protocol.

```dart
const  mnemonic  ='[12 words mnemonics]';
final  ethersWallet  =  ethers.Wallet.fromMnemonic(mnemonic);//see ethers package for more constructors of Wallet

final  walletSigner  =  EthersSigner(
	ethersWallet:  ethersWallet,
	address:  ethersWallet.address!,
);
```

-----

## For Chat

### **Create user for chat**

  

```dart
import  'package:ethers/signers/wallet.dart'  as  ethers;
import  'package:push_restapi_dart/push_restapi_dart.dart'  as  push;

void  testCreateUserFromMnemonics() async {
	
	final  mnemonic  ='[12 words mnemonics]';
	final  ethersWallet  =  ethers.Wallet.fromMnemonic(mnemonic);

	final  walletSigner  =  EthersSigner(
		ethersWallet:  ethersWallet,
		address:  ethersWallet.address!,
	);
	
	try {

	final User? result  =  await  push.createUser(
		signer:  walletSigner,
		progressHook: (push.ProgressHookType  progress) {
		print(progress.progressInfo);	
		},
	);
	
	print(result);
	
	} catch (e) {
		print(e);
	}

}
```
<details>

<summary><b>Expected response (Create Chat User)</b></summary>

  
  

```dart
class  User {
	int?  msgSent;
	int?  maxMsgPersisted;

	String?  wallets;
	String?  encryptedPrivateKey;
	String?  publicKey;
	String?  verificationProof;
	String?  did;
	UserProfile?  profile;
	String?  name;
	String?  about;
	String?  profilePicture;
	int?  numMsg;
	int?  allowedNumMsg;
	String?  encryptionType;
	String?  signature;
	String?  sigType;
	String?  encryptedPassword;
	String?  nftOwner;
	String?  linkedListHash;
	List<dynamic>?  nfts;
}
```

  

| Parameter | Description |
| --- | --- |
| `did` | user decentralized identity |
| `wallets` | all wallets associated to the did |
| `profilePicture` | user chat profile picture. As of now i cannot be changed |
| `publicKey` | PGP public key |
| `encryptedPrivateKey` | encrypted private PGP key |
| `encryptionType` | encryption type used to encrypt the private key |
| `signature` | user payload signature used when creating a user |
| `sigType` | signature type used when creating a user |
| `about` | short user description |
| `name` | user name |
| `encryptedPassword` | encrypted password used to encrypt the private key for NFT chat |
| `nftOwner` | NFT owner address |
| `numMsg` | number of messages sent by the user |
| `allowedNumMsg` | number of messages allowed to be sent by the user |
| `linkedListHash` | cid from all messages this user has sent |
| `nfts` | array of NFTs owned by the user |

  

Example response normal user:

```typescript

// PushAPI_user_get | Response - 200 OK

{

did: 'eip155:0x85e6350861136e65BE141d8DB1eEa25cA346743f',

wallets: 'eip155:0x85e6350861136e65BE141d8DB1eEa25cA346743f',

publicKey: '-----BEGIN PGP PUBLIC KEY BLOCK-----\n' +

'\n' +

'xsBNBGRUAu8BCACV4muD50mKJeGPU33ZkTXi7x6eMpjXlmMQbVERQ7MVKvOc\n' +

'cN+9iz2A18bi73vPYq9FwF/Ibok+A/SuwTbiEe/5E0FXJSnC87DWVF6Aq6At\n' +

'lzCT4WHYlkHU2h5+JNaD8CXOxe6bsGfzbZ9dSZ9zfs5IoCh6Qf035cjV7wH6\n' +

'lcGykxvZUIfKiJuwXotkglGzk0317oo37ZXl6f2hCJBg7NdewXGxVKFYu1JS\n' +

'n5ztzAkoRyiHUnuFDje+HmkU4PjhtrHiFrEeooRyvR/6YCvyIue7f2lIXKV9\n' +

'rOCyczJyDWTf3wwpklDZVEB0Guv4PHcWsTuN1pqyxgz2bT+umctEvla3ABEB\n' +

'AAHNAMLAigQQAQgAPgWCZFQC7wQLCQcICZAzo8jUDaqidgMVCAoEFgACAQIZ\n' +

'AQKbAwIeARYhBNgrG501gFGxwttFzDOjyNQNqqJ2AACgaQf/Rt33rLH7Ayxb\n' +

'UED4L7a5f6aw//jk9Y+yqpB3QbwJTSoD02yUqUJ5J9sW46m8k3eQc6ds4OkP\n' +

'ylaQtoUkumELSuS5hON3Y2IQ78fMvv+My8pQoxD4HzzLj7uVOHaHaElygfoC\n' +

'pfWSDU2UrJB5TK6noOTspcdB5QlCKh5fU0fDtRQ9OKVTM4NTAmYxsDa3OZO6\n' +

'DvqfMAK75tlHJr+Xro7GUbKebaJft/guA2ZHpGTHhs2Q+grjQcvljx6BoN3o\n' +

'NydGwkCorcVZZO7XKr73hPE0VH/LlRqZJ2lcBn/kUJzG1Z1LFYcny+FCrM3U\n' +

'cCg5eI+Is436jSWBl3bhtdYptNwdNM7ATQRkVALvAQgAt7ghdqho1nII81Vk\n' +

'BAs2LN3Vb56GyUCTgZjBP+nbIVat6Kjd2H9dmXVhYEbZMFZyjqAdUwFzoJ8p\n' +

'3Y6qAJxmCktSZ77mzBeojZXi3VesOVfrCzi6MDU+SnN4mguL72YWr6gEbQK5\n' +

'Ypto4uuEh836Dcf7WCj20fTSRvRSKakmBGwnzP/0Gj7fo8S8OQLwFMMEo7bf\n' +

'5ExVuB5Is2SEUxWdeXligBMSiajLJo6thlzs0rTsY/ugbz/czulAMDh1MnST\n' +

'Yol6nHEQUgZFgWx56ARwOn+Y8hJPQqnpWmQie+BakUEabHQjY9sEJ5UDozZ5\n' +

'GwGVrfgETiNblc0crVnUI7CQKQARAQABwsB2BBgBCAAqBYJkVALvCZAzo8jU\n' +

'DaqidgKbDBYhBNgrG501gFGxwttFzDOjyNQNqqJ2AACmjwf/eZuqTjk9MIgq\n' +

'fdlWMM6kLD7W6hScgHIvms9V21Zwy7WQtMrxmQRhCqCHai/eXe/hFABmWxUK\n' +

'nHbosXKL3DQUapvn2cm40BWseW8Il93oRbSQb7xvFQ3g+mNEiSgn0oWBCTSf\n' +

'W9HM/3Kowfc34ilvqfquan+ilCID8OzXHHZXx/nxHeVbpARZiHe2ebk1lr6r\n' +

'KJzq/2S0C65xgn8ShTU1Aewio3+5kr3oHzlTlSnF8Ov5c9VzfEKb+UP7tBMO\n' +

'b8quBez/BgDetebCxaqy881+/LY535i9xVUNDkMK50jY+JvqW10HeuVXOVxZ\n' +

'NrSotIw2xObkCFV2WN46DVNt2S541Q==\n' +

'=Zf86\n' +

'-----END PGP PUBLIC KEY BLOCK-----\n',

encryptedPrivateKey: '{"ciphertext":"7496a39864b0882212956f02270d8b34ad8fbdcbbcf97d359eb8c95eeba70d8daf810d9874ff8cfff5e7840bef8ee12b82a2c7783c28685035ad81dee5233d37570bc4e57cc2d56ac252a14db2cec9777a73094f3efaead3843f59f0a64efcd4f9ded45edb54c3e933811790eee9c5bc9877f9faadf50fe6436510111cf62f1b3419816bdd80f292326b5f58dd8fb595bafe56970479530de30cfd4b3a9c6ca82554016ce902e0bee2db1f636f8e0bd7b2c6f98157220885b07bc9c213a67de847c97c21fabd40440fdaa911219118b9a0efe2ff34fe78fbe2365963f8e2f0d6e22c12d067614d921eb021cea67d8fc36866efe82401ef124de229f27686b93183cfffa75332821939bfd9b5c2ebddb8b388fcee489d06f9bebbc407b68d2a57dd247b3edf51d14010da4cb8325e392475c68383a4dec063e8d8f84e6d553da2c4f84fe9143b2e212e5a17a436d14431e421a7eac40c9e460f37819831f692e9d14617969ecb2cebe4a934f0d36fb85e9694857cb87ebc7186c420362a2582d641bb1112c1bb32822e161ac1c130841ed69d9cdd7c5683352c51315d87abad1c844c1b46017346642482ede19e6be01f8bed93f29fd1d899bc02e99a4463d37b30f3e682877d1cf266c5a30862f27aa9a044ab90cd4e9d069512d0b22f57240480d71671b7d8d9bf3261eab7cb6c0279f159bd53bec28dd48a9f6433f225cc45c5dbaa7d58f0dc6b0e0e52ae0f197d6e9ba458e47ed8dac43351bf1099ce8e367bb67cd706c1a25f5388af9f6370781ecf2296b148eae9e9f554fc3a9dcaffd53cb9650937f1f5d50a566b314542cf5e0994c99fce26053a794f1b38c480ca6a6f344ba023092ca039f37c74b6fee0d0dde4d5553b192cbcdfa50d733d874483a269069e260394a6cb515e2a7a5e6daf6221fe9f7540845457514d38119d858abdcee09595b9266ae06110726391b652881f07f41988abc9080a6dc1fce8929bac13761ca12c66178a487e1d42b07a128e42c6582999fa0e8d2f47ae079ee46c3b13ac058f58e3f27dcfb22e4a2620785ae317258397bc42d64ce0e02c769c426fcfb5b6d9c7862872f19bf1bfae517e60bf853ecbe269143f67c6b2245cba29335a264b3d94a2f5444223aff7f1dab63ee4846cdda557a9b8041a3edc8d5b1ba23f6e4080129e3c25b3336a3ebaf23de2140f1020d332a472795c6f7ab1a767997c6c9a679a1bbdc34415ca83ea46d818af26ae92a0c05c7e8de2a0d960a92975a2709d25c33d2f980a7e5e5b279c6b8c733241b1447448a4b673f28e45d72409a3929b51d86ff3f2fa1aa07e0b355993d2d14035283a366c4d55fb2172bacebd7a7c3745f4e9aebb6096a2a7bb094e29be60aa206c26cdf5aeda9ba7cd40ea291ab7980020fd3b8a69bd1889cf8a347f327b79b21ce370cb2ca75920fd258704da8d23c8df55ecefa528a37adcc06f37113fccffaa958d13b3435fe81823107bf01274c0ab6912cb1960c0d4c7a4f40e3b23b3c50a65785b12ff8663a31fb1718cc6a4dd2a57c3456ad1743c81743c4366d31d987d016f800502c189a12c55e562cb3fb1c198837aa9a9735d3b7d18ea4ce2936df1e579330d773f3da0f7b733a527d11b68accd1fad3166e61b30594b76d8a1594e4ebd692ed4e54d955778d752a707513a5278502dd0ef64c6474c46df0cbba3c763e6366d005a0580f91f9f3674e06421d6ac3828fa2f79cea6d81686926df8092389e04d3e290ce3fc8d9b885b0df75beb5b6307e4fa6f2c4efe7005ac4f3779a48e290d8afdb98ec82046b2621d9ed09cc59f11cedccdeca85962e6b50f4ec9e512da6f547537e75f254aaefb76cb6981f3ccabb7e3230610aa3a50adfe23e04feb1e0b0dc67e1e9e1570808ae3f029583c25fa5f10f983c285d7b2fe0cd13cdd2a91294adcceb3b57bd6687d2b880d963872ba56b5696d63b8110ce4ef7e3af8c7c091fd65b2ceee3bf206d0c54c1127b051d74779545b344389f843eabe5c9459e421176f912ddb2a31f75dd12c964f01ec0f53d164b92c95f175a900e8a707401d2898141ec52d9c3ea619b71e46fc492b6ae9e524c6da32373d19dfbfe9ee3e2a3898fac7f57cff2b1eabd72ab3f48d6021b996a3fd1015ace78742b969a4754ae5a47d510e98f7c02b6833de4c89e1be31d5448a433e3032eaa0e5ecd8b3a40a89f493415dd8c0ca7d467b3ea2e01e902579206354d7dd7936b1593cbd481eca61dd19c62eaf25737c2a70db08f6cddb7776fc849b5cc1ada596d6b07b24f0cae171a281a70f2c8eeed67c74d4b79fc74facbf40d6f89f4f0a91510463454117f1d99d08aef055605452761daea5f8dd47d7f5b7015bc51ccabce1f64c6cbf564eda011fc3bdb3cf809594fa620b98202fd86c0ca5b083f9e77457cace4cc854c37541c1cd2e2faf41bf003eda90165d7b5646ba1884bd9e75c4941ddca0dc1dbeace314021362237795e9993cb438ab45749516b5d7a91ef2b1aa645cf3a054e04893c5bb9fbb1dc4006b4ee7cb4705521d05500a565598097469d0ac7401cb75a08e185dc316901c666f1ecda5e426f45c87a9692045974c1762b25440bdde119d82ec76d33508d26c7c3058a73995182fe82d56e725643cfb722db7bc7a1b7fe36ac1c2dcea391cb7db048e7bb127950f44347e7aa3010e2b72977774ad5b568acc2fd3381e9a7631d196b4a64fd9a1a65b5831b0bb66d78af49a711b7a1e212fd1869847c71a1db467b24858f16b794ff769452bc8be1f3aff7ad38d317de0c235a51b0d28de7b8d0525e7a2278aeed8e6c7cc0419f5967c86919fff31d02b205226d0c1cc05fe81e9bc3c8196aa813deef424ae01d8d140af04b9295658d1c4f8f4958b321dbe38564476d1c43096eeaea7c2d92c81a8a774a277092db570b1ecfb3f36a63006fef8692029ed409d265718ef988ab86bf5f3bd8cdd9de1ecd25c4ba27d5538416a6b86af4d3a2bd6aa3b43dbcbb8862ec2892a3bb7b173daae9ec9d72666f6a9150dda0ebe5edb6f64cc6cda224506e0712975c30c021e1cf83cfc62ed2801252a1d8d5f82f02772d9bc166cf10757c03384f3842d339b27d270f79079e79404e6d933b17530cc9ff004bce21e2cd271e7d9353aef118f99a93ba226d2e78f07e16b40212b2f48d19c2567d5873af7e49bdfe12a9da702409d1c4d7ced214d1e55259442222d827b590484b8b9706b805c25c7162c0c6c9c5d58efa91a9cb9dc6e87349bc95afa5a04c41d1ce41ad594adcfd93fb7357c32b46f1351291ecee68696843fa849da57ed1e50cec9d46d6b99d0a30e70dae05935960e6254e94dba3c6134fd7eac1ff3bf60567fa2a046772a866104823f2904351c6046fe11df8156791057171f0127ceb23cadd2440b0df7d87e5e3eab477b868e69f3da9e78e1fc02626310be982dc2b78367916932b4e16cf9ab4e8eab25480de37714f6f91141e7858a0c5486b274c017310bea58bc4b9af6552a10e255c50130691430d5dc732196b320475c0ebfd35814e1e18c6d0007cd0d1de40565f539a46a7a0bcc40ca8f633a922f278ee4f23677182d001a24676592d375dea7b7187659099b3955465264d97000445dee10669b286b5651e3d4c908ecfaa98a87362ed4674636fc6c6c61de8dd55c024658170751033f6294361c1add6f759317a3390ffdb0da4343a02f5ae3b63d7b7be60b0a949be10e887aa67cf1def7c408db6b89f3258780b998c8a70ad19e2fff3316933a7658191dbb78e25f73a22d1c9a1010421fb4abf243b7170bc8bd83550902af9388d671d402bd74e10f4b0fa82011f9bf34c4d9ca8728b6e7af7b6a1f7dcb2b28c34d6ac8dd6a23baddf7f22851b65ca2fb7e8f69b5cdc4a13bb36ce197f5ca1adc6c1404472afa8fe0f92cbf139a9745cdff3b325cc0b58f1d4410366ec1d3614e8c93f7dbdde78122d7371b81c66b34a4884058f0c0101bbf9e5081392d6a84b7f01e4636d8998f78df9d3a8519906d3aea09e3d67c919351c431ea3a882efe19c35853f15d1689235d6bc453311d8f8f2be841083b048478e5e04e57adfc0e20d0454e25636b995107e4b4ff587584413a5b75f4b500a4244d2b65fcb4a36aced81773339edb8317d4a6c9c3c71a02312b4d41e19f45f4749d91127a5aa993e98ba3fa99e749419455521dccc90e15603e45640383bd455e90d5724073eef83e6093fa9521bc77f5eb563bf398099433dfd7161c1b3a22a8696263c1ebb1cf1b0bbcbc4272c2632e12607164e3688f1ea88bc63622f57d5531a369921c71ada66f62a2ac7a0d7c7d65d9e052ae1484c7112c6426c2f346c002d05df90af2d40137c2ebc2a5b391e7077b8cba458b3a67d4080b10ad1bf7b73b889815e9f94149b44ed0234fddc9c74ceebb1dec82afc6a197257bc84924d2a831c2affbac3262c77da4a9bf1752ea9c3ca041ec6c49f603c052ec568332fb0fbd3ad7374c9cdb0b5b71889eced082feb6f1dabe91bb9819e663a5625dc24671ec0fb00c3c001bc7dee9a886e08be7f52fad9a13bbd2ef913a02a4f144785991ccfa33bb9bb00d42b5660886416ffd756b8c7d027b7ad8a45b0966770bdefcde889d2b155de4ec2721a1b11e7f582426ea12538f1bab2bfba3e0586f2f2302e38d7c398bf8d0b39c36f1e35dfa5e877d29c7e8bd66bb23d09aa6d5cc3091da7988a4acc5b5feacb2d2adc247668b9d7d9f45e51cb3f315d00ec3e5cf7a6ee68001e054f59933c0befcb22c807c7c5c2ab1f679bd2a9401ba10ef6aeb4dd240ecbb23910b07f3edd7dc45830cf29a36ba0325359c2b4871628b3f6163d132023223981bdf2acc5418f3b25db22b0c2575d5865d877386eea6e2d5b80c759057608ace72fc0c803ac46e7eb2678471458f","salt":"7920d0b688208bd58eab85208237ab1ea06e6ca05a692d291581d7c1aea9aa60","nonce":"c2b1e7da7fd7b1659e52e692","version":"eip191-aes256-gcm-hkdf-sha256","preKey":"3ab0388b3b6772457a82cfb7cc125a2d36cd1e568594d0bbfdaee29d3e07c8ef"}',

encryptionType: 'eip191-aes256-gcm-hkdf-sha256',

encryptedPassword: null,

nftOwner: null,

signature: '0xaa451b258c31cdff4e4aaffff5df6b48d8de9ddcb7fa31183c745c0295905705637af5ab3bee1484f11a150bb35db4bbb49243f6439d9e357dc0830685fdd72b1b',

sigType: 'eip191',

profilePicture: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAz0lEQVR4AcXBsU0EQQyG0e+saWJ7oACiKYDMEZVs6GgSpC2BIhzRwAS0sgk9HKn3gpFOAv3v3V4/3+4U4Z1q5KTy42Ql940qvFONnFSGmCFmiN2+fj7uCBlihpgh1ngwcvKfwjuVIWaIGWKNB+GdauSk8uNkJfeNKryzYogZYoZY40m5b/wlQ8wQM8TayMlKeKcaOVkJ71QjJyuGmCFmiDUe+HFy4VyEd57hx0mV+0ZliBlihlgL71w4FyMnVXhnZeSkiu93qheuDDFDzBD7BcCyMAOfy204AAAAAElFTkSuQmCC',

about: null,

name: null,

numMsg: 0,

allowedNumMsg: 1000,

linkedListHash: ''

}

```

</details>

  

-----

  

### **Get user data for chat**

  

```dart

String account = "0x03fAD591aEb926bFD95FE1E38D51811167a5ad5c";
final User?  result  =  await  push.getUser(address:  walletMnemonic.address  ??  '');

```

  

| Param | Remarks |
|----------|---------|
| account | Account address |


  
 
<details>

<summary><b>Expected response (Get Push Chat User)</b></summary>

  
  

> if user chat profile not registered then response is `null`

```dart
class  User {
	int?  msgSent;
	int?  maxMsgPersisted;

	String?  wallets;
	String?  encryptedPrivateKey;
	String?  publicKey;
	String?  verificationProof;
	String?  did;
	UserProfile?  profile;
	String?  name;
	String?  about;
	String?  profilePicture;
	int?  numMsg;
	int?  allowedNumMsg;
	String?  encryptionType;
	String?  signature;
	String?  sigType;
	String?  encryptedPassword;
	String?  nftOwner;
	String?  linkedListHash;
	List<dynamic>?  nfts;
}
```

  

| Parameter | Description |
| --- | --- |
| `did` | user decentralized identity |
| `wallets` | all wallets associated to the did |
| `profilePicture` | user chat profile picture. As of now i cannot be changed |
| `publicKey` | PGP public key |
| `encryptedPrivateKey` | encrypted private PGP key |
| `encryptionType` | encryption type used to encrypt the private key |
| `signature` | user payload signature used when creating a user |
| `sigType` | signature type used when creating a user |
| `about` | short user description |
| `name` | user name |
| `encryptedPassword` | encrypted password used to encrypt the private key for NFT chat |
| `nftOwner` | NFT owner address |
| `numMsg` | number of messages sent by the user |
| `allowedNumMsg` | number of messages allowed to be sent by the user |
| `linkedListHash` | cid from all messages this user has sent |
| `nfts` | array of NFTs owned by the user |

  

Example response normal user:

</details>

  

-----

  
  
  

### **Decrypting encrypted pgp private key from user data**

  

```dart
import  'package:push_restapi_dart/push_restapi_dart.dart'  as  push;
import  'package:ethers/signers/wallet.dart'  as  ether;
import  '../../__lib.dart';

testDecryptPGPKey() async {
	const  mnemonic  = '[12 words mnemonic';
	final  ethersWallet  =  ether.Wallet.fromMnemonic(mnemonic);
	final  signer  =  EthersSigner(
		ethersWallet:  ethersWallet,
		address:  ethersWallet.address!,
	);

	print('walletMnemonic.address: ${ethersWallet.address}');

	final  user  =  await  push.getUser(address:ethersWallet.address!);

	if (user  ==  null) {
		print('Cannot get user');
		return;
	}
	
	String?  pgpPrivateKey  =  null;
	if (user.encryptedPrivateKey  !=  null) {
		pgpPrivateKey  =  await  push.decryptPGPKey(
			encryptedPGPPrivateKey:  user.encryptedPrivateKey!,
			wallet:  push.getWallet(signer:  signer),
		);
	}

	print(pgpPrivateKey);
}
```

| Parameter | Type | Description |
| --- | --- | --- |
| `encryptedPGPPrivateKey` | `string` | encrypted pgp private key |
| `signer` | `Signer` | Signer |
  

<details>

<summary><b>Expected response (Decrypt PGP key of a specific user)</b></summary>

  

```typescript

// PushAPI_chat_decryptPGPKey | Response - 200 OK

// Dummy PGP Key response below

-----BEGIN  PGP  PRIVATE  KEY  BLOCK-----

  

xcASBGP5FCITBSuBBAAiAwMEjbf6BZTz5QEzR6eiZzTKnh4I0k96UTKlqYuoUIHn

tseu+wX3Iir+3Qx8RUMroIfzW4vPfvRT9Asyiy6lgX7INRva5NmcGF5K/Ajb1FbU

etXLQpI2t7jgCBnwZuPYIuyb/gkDCAc1hVXWhLZqYDdwksEN87qo2VmkTc8anibt

Vr3LzZ9HIE0UzVFw5TJ8edc1PUhuNSvECi6bNC5ikq2U36J9laZIui/w8Ep8Qiap

ThdHWn6irZSct2jM2PTxzXi1/3pyzQ1hc2QgPGFzZGFAYXM+wpwEExMKACQFAmP5

FCICGy8DCwkHAxUKCAIeAQIXgAMWAgECGQEFCQHhM4AACgkQE3CXg+QOmOvYFwF/

SFGt6+1HDB5wgJK0I7U+4KBqrbskKosFIiCu28z/+kH4XNsbfAokUeEHGlR7dbTJ

AX9He9aDN/+HVXDluqbFjtiuOPt0o+rh2q+VqlWoZNSd5KYZf5eooLZ5QCeXTwGv

QqXHpQRj+RQiEwgqhkjOPQMBBwIDBK3/1kmZzkyeFy5uGLnLlHrliqg8S0opzQdL

JO7KJ0i4w7sj8ixIk8MCfTlhdOCn9/GJWpj4zbLmh4LRIi1tBpb+CQMIa3eosFni

UqxguopAXYFt/NoA5UWsyBpt4+FyItaSXuuU1h8iFTRC4yuJ0NIlreuudAlwb36R

cLm19yXJh9npgzxQqKKIAHZZpBRdp0alG8LAJwQYEwoADwUCY/kUIgUJAeEzgAIb

LgBqCRATcJeD5A6Y618gBBkTCgAGBQJj+RQiAAoJEO0UKAv9yVcJ8uUBAOm/XYO2

BaQbFNzhZdJBCm/aaLArNKT/+ub+SkI/Fx3+AP0c0oNutj/+5W8b/Ce+UI8at1L4

CymTBlUIl3R2rnBDTQIgAX40L8DDXoEQyXYAzGjB8HcZe7WX2fjxpGm7aj6H8iMo

kYHdfC/mwoUNY1eV8zfsEnIBfR/yFmf3/QT72X+SBaR4D9dw/D0xjSoAyPhYr93H

F00iYdiGdhT/cniA8ZFpFgkfwMelBGP5FCITCCqGSM49AwEHAgME6yddDDmq0ejZ

jbv/mJ395lGDdQVbkJE2Tv5oT0p3rj/9pEh5KJnh9wgmsSf2+22aY9Z19Rv8Wl/l

m4a9PsaZ0P4JAwjRmhmCO7pFAmC1uwxXLWMyU2+eAHdxO1Ss2qaz/5652ExsUuPI

88ZMOX+xo7utXHRNmNWipLdPaJqNbcWhLzYengHrM7On0y5feOO46AGswsAnBBgT

CgAPBQJj+RQiBQkB4TOAAhsuAGoJEBNwl4PkDpjrXyAEGRMKAAYFAmP5FCIACgkQ

ZbEnxLqhlXrZwwEA494obuihsfgTJGjeWansPkhjCvqPGLLfDwVpyM//fYIA/1oU

yVJsET+iG0vMiNigPywJQR6UiGERCQ+Q3XdrczqSEPsBgPswjBYJtRiFi6adx8Yb

LL+rV4kpBdz22i8fEeHkVQ0VpVFcyCjIso+PnyIDFt52QwGA1Zu1NfUps4ooHhfs

n4FxJNoL/lmuCqhQm4Zgduj3GdYUunMDID3k54J1FPGN+iCj

=OX08

-----END  PGP  PRIVATE  KEY  BLOCK-----

```

</details>

  

-----

  

### **Fetching list of user chats**

  

```dart
import  'package:push_restapi_dart/push_restapi_dart.dart';

void  testFetchChats() async {
	final  result  =  await  chats(
	accountAddress: accountAddress,
	pgpPrivateKey:  pgpPrivateKey,
	toDecrypt:  true,
	);

	print(result);

	if (result  !=  null  &&  result.isNotEmpty) {
		print('testFetchChats messageContent: ${result.first.msg?.messageContent}');
}
```

`accountAddress` and  `pgpPrivateKey` are optional if the `wallet` parameter in the `initPush` was provided.

| Param | Type | Default | Remarks |
|----------|---------|---------|--------------------------------------------|
| accountAddress | string | - | user address (Partial CAIP) |
| toDecrypt | boolean | false | if "true" the method will return decrypted message content in response|
| pgpPrivateKey | string | null | mandatory for users having pgp keys|


  
  

<details>

<summary><b>Expected response (Get array of Feed of a specific user)</b></summary>

  

```dart

class  Feeds {
String?  chatId;
String?  about;
String?  did;
String?  intent;
String?  intentSentBy;
String?  intentTimestamp;
String?  publicKey;
String?  profilePicture;
String?  threadhash;
String?  wallets;
String?  combinedDID;
String?  name;
dynamic  groupInformation;
Message?  msg;
bool?  deprecated;
String?  deprecatedCode;}
```

  

```typescript

// PushAPI_chat_chats | Response - 200 OK

// Array of chats

[

{

chatId:  'dafdc288ccd416c22caa8adfc2c62ee23e83b2e351f60df91531e82fa7ca243e',

about:  null,

did:  'eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

intent:  'eip155:0x1615d2D9ae82D5F0eE79298899962b237386feB7+eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

intentSentBy:  'eip155:0x1615d2D9ae82D5F0eE79298899962b237386feB7',

intentTimestamp:  '2023-05-08T12:56:16.000Z',

publicKey:  '{"key":"-----BEGIN PGP PUBLIC KEY BLOCK-----\\n\\nxsBNBGRYo/8BCADhbpiwQf8PEXdi1V2BKfoHs8Vo7dM0FvukAlTGlk/778kV\\neriOXsBmFT3PciLWXRbh5CqsxXmshY030Ugb6h9x2FcgglzsLhJxc8cbCbpk\\nlK3wkZSAJbPX42rX6y2yvLZffdziAddliJFnE0gfV5WD/rxugYP/FIHyGt9y\\njKXuDwNAihp5qQeXaPs+vEqaVhExGUlwWhbBj/EepD8LMc4+inZMTBNxN213\\nnZTSWudaV6mnnrKNjkHTtK3tT6TTHAb5f5Xoz+zTNbMQecktRtF4r27ctRgQ\\nBUEnFkREdQR9vAmJuMmDeh0SKFAE44bNm8moSTHtwSyyjfoL2y7rLmkLABEB\\nAAHNAMLAigQQAQgAPgWCZFij/wQLCQcICZC/GLX8yhr5DwMVCAoEFgACAQIZ\\nAQKbAwIeARYhBIXvLPhJE+agImuJ578YtfzKGvkPAAA8eggAx6GWFsiVU0Jd\\nj3FxkYPwitvF2PdkzPKKLczhj82zNAt4njioYijjpItjw8Wq0cyWtTKfwb0v\\nZ5ty1X0MsOZATsF46PBz0nsBp7BxDutFjgKHQxGwlss+WD6yYqujPUdzmhMO\\n5KYh/McDrGhP939UZhSRhvAH78Id+2EG8Q74KHgAhfcrJvpHf/aBrF1+Gn07\\nSGuZ4GpzqVO7NaQlme1BAAFSZI+EZeCoCODZXJ6gdh1HC1/splLYtcT+FL0/\\nj0VQxVoaVpD5B5AgIQJp1QeFOIcLcFecRLY+RiXkfNJHHbkcCBXGTHuPY5CT\\noIohJfb45Y8wSjcZ3Ec+YOf+00UmP87ATQRkWKP/AQgA2MUK+aUDZE3PFaXG\\n/0H02iqUzu18FmSnPW0TmisHezdzI/LcZwqKapJawxHLsPiGK42xWa2ZBwgh\\n8xyMhspY9jv9u3uDaR/vR6y83+KaUlsSyvpUu0HAapWVIlE79p1/lLld5+Ui\\ny4Ap8VPMSd7sU0TZXGw/s8sBol1Lv1O1wJj0gc17IB1dahMppxnZlnoCtqBA\\nNeFZ8Ssx7+ZAhfvglCqvBo154+4UphqZLoGmGCZWIY3B3NU1EGRjQNnVNaSC\\nuRet3Qi85ni++52k6wR3tJLDqOxFKnYrv93nPENABSuYS8Uc04VvE0hfbjNF\\n6qeo5gah5O68F/xtI6MATZRIAQARAQABwsB2BBgBCAAqBYJkWKP/CZC/GLX8\\nyhr5DwKbDBYhBIXvLPhJE+agImuJ578YtfzKGvkPAAC3zgf+LZ2aNe1nY3au\\n9T57MqhfTMYIEWn/PJ0LAJFg3jgPTmzL4K+ZLSTdWEV7p8aMKrTloYSWENW+\\nuuj+MhMnOC1EonhmqYGHrsFTPdZR902a/mNPnxl8A8r7ixq1OAgq81qYVsQ1\\nQaC8uuJaqCxLediM5lVP95xz1qdKgNhKtG7cPlX8ljAL4KE3U2/Jjj/KiqED\\n0XaMqrt1y2qjjNF+ct+NbmqmwRaOKq8mWpFlPygA9dq6Sp1nCcwvYmxBQrbg\\nmTDldPF6tg7SqF83DN7DnUQt1cNQEUUv8SUiGnS/Dd01nhManNBLNtNpgCCf\\n4etbnA/WK08gsOhSeM3bBOSOjavwmA==\\n=qZBP\\n-----END PGP PUBLIC KEY BLOCK-----\\n","signature":"eip191:0xc56d79a25a832134b0438981f534c1c811bb8d1d1ea6f19b639e4dbc1fb64a4c65be377120dc4402d29b371dc378f00289640b037f6ad9e475fab5781ce067b81c"}',

profilePicture:  'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAyklEQVR4AcXBoa3DMABF0ZunTFBSVNQBAr1IFdA1AoMNvYiVRQy9QSUPklKX+Cv64J0zfdrz5IKwBEZKLVwhzISZMJv5Q4uJX5mRFhO9x74xIsyEmTCbW0z0HvvGyLGu/EeLiZ4wE2bCbLrf3idGwkyYCbO51EIvLIGRUgsjYQmMlFroCTNhJszmFhO/Mr1SC1eUWuiFJdBrMdETZsJMmE332/ukc6wrI6+cGTnWlZFXzvSEmTATZtOnPU8uaDEx8tg3rhBmwkyYfQE/njNZjYo1IgAAAABJRU5ErkJggg==',

threadhash:  'bafyreidfnsaz7pz3hsedtlgzj7beqnwj44h3bunpaouwmk4r4i5y5psyti',

wallets:  'eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

combinedDID:  'eip155:0x1615d2D9ae82D5F0eE79298899962b237386feB7_eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

name:  null,

msg: {

fromCAIP10:  'eip155:0x1615d2D9ae82D5F0eE79298899962b237386feB7',

toCAIP10:  'eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

fromDID:  'eip155:0x1615d2D9ae82D5F0eE79298899962b237386feB7',

toDID:  'eip155:0x1C48fE875590f8e366447758b13982a3Ca7d9dBE',

messageContent:  "Gm gm! It's me... Mario",

messageType:  'Text',

signature:  '-----BEGIN PGP SIGNATURE-----\n' +

'\n' +

'wsBzBAEBCAAnBYJkWKQWCZB7dzg7q3axjBYhBJFuYslzDGbuE+3FMnt3ODur\n' +

'drGMAAAjtAf/TXjtm2qb6aSikFPKYXm0Ekws+65fisJGf7T48MYkkfcD4t2e\n' +

'HXd9LtohzGhcztbOQfAND3yME1GWuMBIksq9rlyEA0ezwsGzCJVhBnkAHBe3\n' +

'+1v4/mNSMmInU8y6sOiLiOcW7ameJvZvDdPDJ0YHhc9dKDCIh1UAZEPAgx+z\n' +

'Wc0DM6pW8bT70dfgnuW2LlLGF5Z23Z1vbHmeszt78+xYY3ez/hoMHXUIE25z\n' +

'Wrnt75nasBBahtJ0mwH10ATnsQNE9hTi6XPGYxRSNDM9nyRxTQUpjhNmGS/+\n' +

'7oFyq8xTcRSaL7d3h8URp9hgFWher5ZZDyMV0jvk+HPguUX54g6Kgw==\n' +

'=dcRD\n' +

'-----END PGP SIGNATURE-----\n',

timestamp:  1683530775648,

sigType:  'pgp',

encType:  'pgp',

encryptedSecret:  '-----BEGIN PGP MESSAGE-----\n' +

'\n' +

'wcBMA9aU+JGZVRn/AQgA1pIJHyeJinU21r6At5S5ZaWeN0OEKVB2TjpqZ0IW\n' +

'lHLKQrQ8k3M16bN+Vf0P+DzDVOL84QRkBD56qSNVHOOCox5wcQeR01CczenV\n' +

'LUVvVjBzR2hj7Sdw+Q+M//rgeZPPUDbNyiVmGijelhwDqWd7IOoZY26AGXlm\n' +

'7YQiElvHN2HcYXaTlLAOy36BcccwHu3Tn06F77ZXaf8FnGMWOUy7wh1/jugg\n' +

'D17jUZGLYbmw+u5l9BOfljbw2pb4vtjWht0I1b4GYlKb+bYg/NY0UNsq7mSh\n' +

'dGAmOhy5tC2NMjLRRLfD2qasxHoHN50onlB6HcYLl0RCf31ebOgO6rMhUnxt\n' +

'9cHATAMLWLG2xubrYAEH/2tVeq2j7nJALGSFxjJPboOY57aiFrhXNQ/e/oXH\n' +

'//TNJgGWx4Ta++OuF2Oexbh9DIZhl6DWld9adXDDtBS/fEyjNsYqwoYlNEJN\n' +

'kLvSmokNNrE4MKC1A0GkhSh2MGQDNk42GSgz1tep8XSVc98MHqfNXCHVb5Oa\n' +

'OBeWKLFyElT3+KuZxSkCsnoO5YjuCGbXPyG06tXMHXMTncpj1ri+vpjUSnhD\n' +

'wn3o0zpNWu0GaWXIgTqj2ZouVwV2S1+wAJQjE8uI1JvBiMhA+X63/GCcApBu\n' +

'C7rN0Cs5NGXCn9VWp8i1SCp2NuZ38POABwsXUUkjpF24txyUDX8dbXlkzpao\n' +

'g93SQAElYYmyKbGp1TKhAZl2u40mgf2yCYDv2DLRfAKMJDLvmjXoUGEg2UYO\n' +

'11w6LD0pIykdKJmFtRls/uMnlcoBgDA=\n' +

'=kzUH\n' +

'-----END PGP MESSAGE-----\n',

link:  'bafyreib34jgnpp573rwquejcq5avxvydis7fbykat6dd5z7uazobucoumm'

},

groupInformation:  undefined

}

]

```

  

| Parameter | Type | Description |
| --- | --- | --- |
| msg | `IMessageIPFS` | message object |
| did | `string` | user DID |
| wallets | `string` | user wallets |
| profilePicture | `string` | user profile picture |
| publicKey | `string` | user public key |
| about | `string` | user description |
| threadhash | `string` | cid from the latest message sent on this conversation |
| intent | `string` | addresses concatenated from the users who have approved the intent |
| intentSentBy | `string` | address of the user who sent the intent |
| intentTimestamp | `number` | timestamp of the intent |
| combinedDID | `string` | concatenated addresses of the members of this chat (for DM the 2 addresses and from Group the addresses from all group members) |
| cid | `string` | content identifier on IPFS |
| chatId | `string` | chat identifier |
| groupInformation | `GroupDTO` | if group chat, all group information |

  

</details>

### **Fetching list of user chat requests**

  

```dart
import  'package:push_restapi_dart/push_restapi_dart.dart';
void  testFetchRequests() async {

final  result  =  await  requests(toDecrypt:  true);
print(result);

if (result  !=  null  &&  result.isNotEmpty) {
	print(
	'testFetchRequests messageContent: ${result.first.msg?.messageContent}');
	}
}

```

  

| Param | Type | Default | Remarks |
| ------------- | ------- | ------- | ---------------------------------------------------------------------- |
| account | string | - | user address (Partial CAIP), optional if the `wallet` parameter in the `initPush` was provided|
| toDecrypt | boolean | false | if "true" the method will return decrypted message content in response |
| pgpPrivateKey | string | null | mandatory for users having pgp keys, optional if the `wallet` parameter in the `initPush` was provided|


  
  

<details>

<summary><b>Expected response (Get chat requests of a specific user)</b></summary>

  

```typescript

// PushAPI_chat_requests | Response - 200 OK

// Array of chat requests

[

{

about:  null,

did:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

intent:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

intentSentBy:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

intentTimestamp:  '2023-01-07T03:51:11.000Z',

publicKey:  '-----BEGIN PGP PUBLIC KEY BLOCK-----\n' + '\n' + 'xsBNBGOhhq8BCADP5Nzw0jOXhKO86ndGkY/JlD8AadVXmsLA+Yvoc22LrNTU\n' + 'QrfcDWaMAzpmtMWJlNEHSTieUPEgODm/qj422+rdskSedum3gq1HWn2bmqEI\n' + 'LrFc+zR3B70Pe7saEEmC/hXG53/8m7V0HsOuvkEjBa3pW3KElZIhimVvcgYR\n' + '9AnLjUYKR/lci1eXXsAz+J+RjgPlFfiIE0/3KYXwkjt9meSJDPCIcEIZ1tqw\n' + 'IkGRINM5XINMvC+FxPNQ+jIHF9WIzmUg4YfYZQbMo96j4LAV0kYvAB0qI2Y8\n' + 'DHAjHXYQ+fafRGOJwePASjDHUjcB9QEr1EPIMG3i4iFaBV2ZmePjzE7XABEB\n' + 'AAHNAMLAigQQAQgAPgUCY6GGrwQLCQcICRCUVlBnqYwnwgMVCAoEFgACAQIZ\n' + 'AQIbAwIeARYhBPYJKSdUrZzVgB9jy5RWUGepjCfCAABLZAgAtVdxz75k3qFY\n' + 'qtwMdsrIPX4A7rpT/zCd2Yjl2asFdlkyAusfNdFEiff1dHz5+qBM88z/Zh+O\n' + '1FNDKS/WKL9qmZ+AceyidCjnRVTUeH6Mi/ZD/YZInJyLozCksb0Gciswl6Rp\n' + 'RHb6nXt0PebUFXTsOVxSeodaEGBgltd/V1bDHpfx8Wu03z3h/Jq2tI4s28XA\n' + 'S2lSZpG8+nC1zLOmpbYx8mdOe00ONBdnMvxAqckd437ns7Tu8sKW4SsRzjg1\n' + 'YHTmApRjai1L6bHn0P5Utz0BcynzrUn+bZ0cC+5Rq3kZvrjnaJOIutY+ALDF\n' + '4yWoVIz8KzzAUx1caVyVvwdFtjVTS87ATQRjoYavAQgA3nCB6WLASwBwp5r/\n' + 'WU8SiUzf/2srENNObpjxavmv2FVKcKfO0ehSi6ti22KSKnUgm5prlOMWsVl/\n' + 'wEClvpGw0Btdar4OQI7XdwkY8XUVB5Jff7cNpi4qE+4lIYqCTQief9H5GLC/\n' + 'QvpE53yZWGFK581OSaeomtibN5xAaUyEE8qITnYyjqA+SgffRFVN5/WOnnBK\n' + 'zbIHrXl2lXOFkegXaOk+Qxxikw9cSpHNV5YHVoDStRCJZKVU8JhKa7pYKkmC\n' + 'pSIiXT3IdSAqDiglDRxwX4KlFFhGZ1OGbBmPefN3pZ7/xvaM28TqSDNB7f89\n' + '/lc5UKLz5Em2aroEclT0YpKYGQARAQABwsB2BBgBCAAqBQJjoYavCRCUVlBn\n' + 'qYwnwgIbDBYhBPYJKSdUrZzVgB9jy5RWUGepjCfCAAC6rwgAji6/qPQn/BN/\n' + 'BbwGBN+A8tWRuQLwrgOilg8oHWkyCIUK7DeBp+gpkSghjsnaEAqc94xaGD3U\n' + 'AfgcPGmC/Jx92W+bX8P40Iq8OvPgLgvG1u5Rf1a1SNYAuypQemuHYu3HOvUU\n' + 'vP+0omoiTWyNZVqsZA0FGIYQk9uRg8KGsLvXwzPPLqC5Yo3fyfQUmytBZfEf\n' + 'OwYwuvzx1RBHtvyZ32sfq//q4t2fXY0d49rg6l475zo3JsZsYtqZJCf9h6uK\n' + 'MrSFgvn8mJFlpwI1+g7X46VB+t8D1Ac35r9Bn9UIWieIyS2Aux2UwBsY2iET\n' + 'CdgkH8gWFBU7bdKsFh7BQX2ZhrxHXQ==\n' + '=Lr7Q\n' + '-----END PGP PUBLIC KEY BLOCK-----\n',

profilePicture:  'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA1UlEQVR4AcXBobGEMBSG0W//idlKiKARaohMAzEIzFoEhgaQ1EAV6xCkmn32PpMZZue9e87j9Xx/uKGkSMu6X9whnAlnwlkoKdKy7hdWnTJN+4hVUqRFOBPOhLPH6/n+YAznwl86+hFLOBPOhLNQUsRa+5GW4VxoOfqRlpIilnAmnAlnYd0v/tO6X1jCmXAmnIWSIladMtbRj3xjOBesbt6whDPhTDgLdcrc0c0bLQcXLXXKWMKZcCachW7esOqUsUqKWHXKtBQ2rMpv3bxhCWfCmXD2A590MfREqrg1AAAAAElFTkSuQmCC',

threadhash:  'bafyreigs26i7k3g5u4xmqg44tecmkfvelclp5lletnikfbsrj7dhg5oi4y',

wallets:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

combinedDID:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029_eip155:0xD8634C39BBFd4033c0d3289C4515275102423681',

name:  'copper-screeching-herring',

msg: {

link:  'bafyreibuez6o5hqqf6j45ekqxz7ixdtbxs6mhu3m6iv63etja6p2g43qom',

toDID:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

encType:  'pgp',

fromDID:  'eip155:0xD8634C39BBFd4033c0d3289C4515275102423681',

sigType:  '-----BEGIN PGP SIGNATURE-----\n' + '\n' + 'wsBzBAEBCAAnBQJjuJ7WCRCszcBmB607ShYhBEWdLV876c+znjS0l6zNwGYH\n' + 'rTtKAAAEUQgAiSLgvLRf4UM/VIOImO4I/CHt5vBCqvOjq8068K5Bb2ciRn0o\n' + '8IqLV2eYKe8c0LK8Gf/CzZn7S13eux4FUlXcX7TlU9BpgHAVQIP4gDe7Q1XN\n' + '1+rXFH+QW4P/Zv0knObHAby/7wYfD1ZfBrLbo5SpZEBDYQNYZ5t29y7aVD5e\n' + 'QMOoSvj5+y6SLDLJalb5daeSfaZtpNBsTZvUBLndNomT///gzrXRutkgW4T4\n' + 'bDipFPUvLMNvWM1qXJjDyYbyQnr8J8aq3FKoGs4Qs5Z2wcwx9RF54Izh81vd\n' + 'Y5jkZdpULqxjB4BH2mFGyB9Cp2e5cIpKriY597JCAc6Y6WfhgbIZoA==\n' + '=n2B5\n' + '-----END PGP SIGNATURE-----\n',

toCAIP10:  'eip155:0x69e666767Ba3a661369e1e2F572EdE7ADC926029',

signature:  '-----BEGIN PGP SIGNATURE-----\n' + '\n' + 'wsBzBAEBCAAnBQJjuJ7WCRCszcBmB607ShYhBEWdLV876c+znjS0l6zNwGYH\n' + 'rTtKAAAEUQgAiSLgvLRf4UM/VIOImO4I/CHt5vBCqvOjq8068K5Bb2ciRn0o\n' + '8IqLV2eYKe8c0LK8Gf/CzZn7S13eux4FUlXcX7TlU9BpgHAVQIP4gDe7Q1XN\n' + '1+rXFH+QW4P/Zv0knObHAby/7wYfD1ZfBrLbo5SpZEBDYQNYZ5t29y7aVD5e\n' + 'QMOoSvj5+y6SLDLJalb5daeSfaZtpNBsTZvUBLndNomT///gzrXRutkgW4T4\n' + 'bDipFPUvLMNvWM1qXJjDyYbyQnr8J8aq3FKoGs4Qs5Z2wcwx9RF54Izh81vd\n' + 'Y5jkZdpULqxjB4BH2mFGyB9Cp2e5cIpKriY597JCAc6Y6WfhgbIZoA==\n' + '=n2B5\n' + '-----END PGP SIGNATURE-----\n',

timestamp:  1673043671357,

fromCAIP10:  'eip155:0xD8634C39BBFd4033c0d3289C4515275102423681',

messageType:  'Text',

messageContent:  'hey',

encryptedSecret:  '-----BEGIN PGP MESSAGE-----\n' + '\n' + 'wcBMAzJsNgcerTKoAQgAvzX9pBj4j7ytnwU7DwMsCMl6PUDx6qAQybQxrlby\n' + '+xkP1Cf1tOkLj1HP/oFHg3cX5HioM600jAaIYhCr8ib+M3ydvhKnti0mcpbn\n' + 'VnbWilrzyFUBE7T3eZY54JeFxIQ9mtjl/TmGryXpWD9FHjnSp22NRnbZIcZZ\n' + 'SHpatgDZYzRhHf9zqusBH2QUDKX1Ty7dIq9JD2AeS55l40IHNMPcP2btxfY1\n' + 'T7od8WvFYhlWQGtkbm8k42fwdK1mIJ3H/rOSeM8sTliYAECe+IhmpIevg4II\n' + 'Eel7eG81HjGciWt3Vs3FXkhuEUbQnMRAKfhaqalJNDriaWwzUMMt5a/rWdS1\n' + 'gMHATAN7roGwZ8OLswEH/2RmDHNAaDi11UT3uLAuQxNzlLeqxFaTPecSFaEW\n' + 'IFdJ+3ujcy3FHoyndK0S+ucFhP2V0hJRMHyyMiKNKSuUp6Q03NZ7Uqavqku3\n' + 'kVfAJ3tH6jlUWNetvV8t95OmYInqhC4MNk0nIhdI10bl89KmNRqsfQqKu5Hn\n' + '5b9Jy7B+XgjKNdj7iWx0FuFabVIQ3NIDnVBDLy8/mDTeB1HuAv/7KljBr0fC\n' + 'TtzSZij1Pu5+aIPWaGG2hJvxga9g5Zqfvdm79Wn3gfoOCz3FdXcp/n3732rY\n' + '+mrIE0DVUlWa0YbVotcSCzLlUpXlFts85Ok8W/N8ERtBMbbd2+e2tBKAP8Hs\n' + 'iYHSQAHz9V5LwQaFvujErtV5KZfD5DnB8RlUVJU4JKLDgYiXaP18O0fpsZyO\n' + '4fym770psCEPU4sc+flSJ0SxBa8m+yM=\n' + '=Cp3M\n' + '-----END PGP MESSAGE-----\n',

},

groupInformation:  undefined,

},

];

```

</details>

  
  

### **Fetching conversation hash between two users**

  

```dart
import  'package:push_restapi_dart/push_restapi_dart.dart'  as  push;


void  testFetchP2PChat() async {
	final  result  =  await  push.chat(
	recipient:  '0x9960D6B63B113303B9910A03ca5341B83CC52723');

	print(result);
	if (result  !=  null) {

	print('testFetchP2PChat messageContent: ${result.msg?.messageContent}');

	}
}
```

  

| Param | Type | Default | Remarks |
|----------|---------|---------|--------------------------------------------|
| account | string | - | user address, optional if the `wallet` parameter in the `initPush` was provided |
| conversationId | string | - | receiver's address (partial CAIP) or chatId of a group|
| pgpPrivateKey | string | null | mandatory for users having pgp keys, optional if the `wallet` parameter in the `initPush` was provided|
  
  