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
___
# Create Space
```dart
void testCreateSpace() async {
  final ethersWallet = ether.Wallet.fromPrivateKey(
      "c41b72d56258e50595baa969eb0949c5cee9926ac55f7bad21fe327236772e0c");

  final signer = EthersSigner(
    ethersWallet: ethersWallet,
    address: ethersWallet.address!,
  );

  final result = await push.createSpace(
      signer: signer,
      spaceName: "Testing dart - 123567810123",
      spaceDescription: "Testing dart",
      spaceImage: "asdads",
      listeners: ["eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723"],
      speakers: ["eip155:0xffa1af9e558b68bbc09ad74058331c100c135280"],
      isPublic: true,
      scheduleAt: DateTime(2024, 01, 91));

  print(result);
  if (result != null) {
    print('testCreateSpace response: ${result}');
  }
}
```
Allowed Options (params with _ are mandatory)
| Param | Type | Default | Remarks |
|----------|---------|---------|--------------------------------------------|
| account_ | String | - | user address |
| spaceName* | String | - | group name |
| spaceDescription* | String | - | group description |
| spaceImage* | string | - | group image link |
| listeners* | List<String> | - | wallet addresses of all listeners except speakers and spaceCreator |
| speakers* | List<String> | - | wallet addresses of all speakers except listeners and spaceCreator |
| isPublic* | boolean | - | true for public space, false for private space |
| scheduleAt\* | DateTime | - | Date time when the space is scheduled to start |
| scheduleEnd | DateTime | - | Date time when the space is scheduled to end |
| rules | Rules | - | conditions for space access (see format below) |
| pgpPrivateKey | String | null | mandatory for users having pgp keys|
| env | string | 'prod' | API env - 'prod', 'staging', 'dev'|


<details>
	  <summary><b>Expected response (create space)</b></summary>

	```typescript
	// PushAPI.space.create | Response - 200 OK
	{
		members: [{
			wallet: 'eip155:0x727C819feB2c7F99c66d71B8411521bca2010023',
			publicKey: '-----BEGIN PGP PUBLIC KEY BLOCK-----\n' +
				'\n' +
				'xsBNBGSrssEBCACg3ZjrZB40Xqr5IKIEtFldaeQyJPNwDACMekY77yApav0B\n' +
				'RwiqhFJDFJKcprSHg/vYdqalAIGRQ+J98VMBtHweurIubD/ODB6WknOms7ZY\n' +
				'3ummaEzyFRombuq/C75o/0ImCi2v0PJBI3kdpwzOjiTt8S44yoAVOcTf9jyg\n' +
				'vTEVCOM81yqCf0mDB4t0jqRYewlQuJegORXDKHKTfZcnQybBkDYUGgmxOcyF\n' +
				'BaPMhSiWqAAqqb4gcFO2QKq69JoiE9dzSuF/7dvAq2QZRogC/GQW2Q9yQbq3\n' +
				'CvMNO4H2KUZzegaq2s2nMPGMXPNf4GZcZVJE1phWgAnApxTf5kUFfKr1ABEB\n' +
				'AAHNAMLAigQQAQgAPgWCZKuywQQLCQcICZDwrCS5ulOLwQMVCAoEFgACAQIZ\n' +
				'AQKbAwIeARYhBFKpO7zcSRed+QmbIfCsJLm6U4vBAABZMwf+OIbBcFQ7x++1\n' +
				'NINOYbP9v0PyJvpllDcUORbk3uiPMpvDuQYAe2Fd4dY2Y91l3VdpIm/w6HQy\n' +
				'y81Y694w4E7PRVhDwHivv5D10VE9MF3h6qOHrLLpvdhpMaB5Ur8ts5rU2zOu\n' +
				'64HR04/BVO9N0nrE9iywIgVMOy6IrS+OgK3r75PPX35bam/kbbmZHeygFaE9\n' +
				'+mgQVdhwgF5borekIiz1Rc8CPA/P1yZy8QQl4KGmJEs+hOc5rPnUWwarvaAH\n' +
				'mPb6H0/mG81eXBOjpJlSFu6d/uqKLpoAw5fkvFoIsNwovYpyQkSbhzwe4T2N\n' +
				'jGqGd0+La03QdB5FbaiwcnJ96lU6oM7ATQRkq7LBAQgAxu9uK1+p62+/RvcF\n' +
				'Mz7g3A8SJiN76NYxk29sjQ9gW74B/IdPv5TlUVhG6PGr2c3SucASlEHieagY\n' +
				'CXM2+fpdu4rQ6EKRAe+30GFopfzhX1d0zv9d5BE6q1ML5mkrpDECH5iuqah7\n' +
				'smmbRdWE7zRSGaHyEfVqAG3wfMzzN0BcchxxR4vMCNKYLs9v2Q09ecO7DgaY\n' +
				'5CZqxaFlTo+auuDhE0XU7WRbNL77izocV1Sm+McRyo28PrFTcrRRznD1nP0V\n' +
				'eZ4+aoulqyYA+gBBaIUdSA5kQXJiy67crB50yX3V6zLIfptD2ThHPjTY/inW\n' +
				'wVHVug4jIWUQ1QQw/q9qvGxAzQARAQABwsB2BBgBCAAqBYJkq7LBCZDwrCS5\n' +
				'ulOLwQKbDBYhBFKpO7zcSRed+QmbIfCsJLm6U4vBAADu6wf+NJDX/3NAxQKN\n' +
				'Iigj0GkBm/y69iFmQvWJxxtiYCNu8VBhm8MkcghUJ8G2tWP9ueUOM8sMTEa+\n' +
				'G+l+wSNwh/1yisF3FutDpy6l+fiy6kPPD4vl08jY3GrqSuWWfMxTJhMZ5D6v\n' +
				'OW2EfdyET+oP5eOnCd6p0EXP2ic48rVHDdU2iWeg0RkGvZP3t2LljWFdLbvw\n' +
				'h7+wSD1i4LY4slUIdbLdDSLN1gWFN1HXzX10mpX0grV2sBdfkNyHhF0WcIat\n' +
				'sD9HpAx2M62yP2D9D9UZVrW7WfmOoyL1NrnXSJsI8CRFDzujvpIrr7875zSi\n' +
				'VnxDVyt7twc7cYqRDHsNYuxAuE815A==\n' +
				'=2jvb\n' +
				'-----END PGP PUBLIC KEY BLOCK-----\n',
			isSpeaker: true,
			image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA4klEQVR4AcXBoW3FMBRA0dsn75E9skAU6BkMSk1CA0xNsoBnMLSyQPbIDgVlLX0OcPX1Vb1zPj6/v35QWg5o61bQok+MHHVHazmgrVtBE4wJxgRjjofzmuj4xCuiT2iRCe2gJxgTjAnGXMuBTi2MRJ8YOerOSMsBTTAmGBOMuXUraNEntKPuaEfdeUX0iU4taIIxwZhgzPGH6BP/STAmGBOMOR6W+UY7r4l3LPONttITjAnGBGMu+kSnFrQlB96xbgUt+oQmGBOMCcYcDy0HRs5rYmSZb7SWA1pkQhOMCcYEY78uSjTZAXCkaQAAAABJRU5ErkJggg=='
		}],
		pendingMembers: [{
				wallet: 'eip155:0x5f4e9e7Fcc17a943178c0b0881b09E8Ef9D34437',
				publicKey: null,
				isSpeaker: false,
				image: null
			},
			{
				wallet: 'eip155:0xFedfA2b276676C5c6ce753ddb4B05d00104E9236',
				publicKey: null,
				isSpeaker: false,
				image: null
			}
		],
	  contractAddressERC20: "0x8Afa8FDf9fB545C8412499E8532C958086608b30",
	  numberOfERC20: 20,
	  contractAddressNFT: "0x42af3147f17239341477113484752D5D3dda997B",
	  numberOfNFTTokens: 2,
		verificationProof: 'pgp:-----BEGIN PGP SIGNATURE-----\n' +
			'\n' +
			'wsBzBAEBCAAnBYJkq7LBCZDwrCS5ulOLwRYhBFKpO7zcSRed+QmbIfCsJLm6\n' +
			'U4vBAAAAHwf+K4f0gxaP56X4Cv2zlPWB9iUPi/1FOnx8ZF7oEf9xJSv/xA7v\n' +
			'9LHBTZ2Y9AQlJpy0WLB7KGF7mVV1MdUKHjn2SFQ+1h+8d+FIHXfmB7Ie4alP\n' +
			'nnar6XjtMVKYyqXRzMzCq2F7Fjea1sUOXBxAeyJstAGG6nvsU51imaAtGQlQ\n' +
			'u7ih8D9UkiOe719v5GyI1vtiS+hHGlYo0+A7WVImH6SuVyPZ3UyPvLxXpeKs\n' +
			'1SeEfuvfmKHbswm1DDGOknyo7fJ/QgKqOfkwsBIrYRNGwPGEKt8pHdwNxsNn\n' +
			'hNQtlFqtmtvieaxbhJQKXHbVgNv206xNsUBrK/U2nCakx7EMmxikFg==\n' +
			'=tz9T\n' +
			'-----END PGP SIGNATURE-----\n',
		spaceImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAvklEQVR4AcXBsW2FMBiF0Y8r3GQb6jeBxRauYRpo4yGQkMd4A7kg7Z/GUfSKe8703fKDkTATZsJsrr0RlZSJ9r4RLayMvLmJjnQS1d6IhJkwE2bT13U/DBzp5BN73xgRZsJMmM1HOolqb/yWiWpvjJSUiRZWopIykTATZsJs5g+1N6KSMiO1N/5DmAkzYTa9Lh6MhJkwE2ZzSZlo7xvRwson3txERzqJhJkwE2bT6+JhoKTMJ2pvjAgzYSbMfgDlXixqjH6gRgAAAABJRU5ErkJggg==',
		spaceName: 'wasteful_indigo_warbler',
		isPublic: true,
		spaceDescription: 'boring_emerald_gamefowl',
		spaceCreator: 'eip155:0x727C819feB2c7F99c66d71B8411521bca2010023',
		spaceId: 'spaces:e0553610da88dacac70b406d1222a6881c0bde2c5129e58b526b5ae729d82116',
		scheduleAt: '2023-07-15T14:48:00.000Z',
		scheduleEnd: '2023-07-15T15:48:00.000Z',
		status: 'PENDING',
	}


	```

</details>

---
# Update Space
```dart
  var spaceDTO = await push.updateSpace(
    signer: signer,
    spaceId: result!.spaceId,
    spaceName: spaceName,
    spaceDescription: 'YourSpaceDescription',
    spaceImage: 'YourSpaceImageUrl',
    listeners: [
      'eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723',
      signer.address
    ],
    speakers: [
      signer.address
    ],
    scheduleAt: DateTime.now(),
    scheduleEnd: DateTime.now().add(Duration(days: 10)),
    status: ChatStatus.ACTIVE,
  );
```
| Param | Type | Default | Remarks |
|----------|---------|---------|--------------------------------------------|
| spaceId_ | string | - | Id of the space |
| spaceName* | String | - | group name |
| spaceDescription* | String | - | group description |
| spaceImage* | string | - | group image link |
| listeners* | List<String> | - | wallet addresses of all listeners except speakers and spaceCreator |
| speakers* | List<String> | - | wallet addresses of all speakers except listeners and spaceCreator |
| isPublic* | boolean | - | true for public space, false for private space |
| scheduleAt\* | DateTime | - | Date time when the space is scheduled to start |
| scheduleEnd | DateTime | - | Date time when the space is scheduled to end |
| rules | Rules | - | conditions for space access (see format below) |
| pgpPrivateKey | String | null | mandatory for users having pgp keys|
| env | string | 'prod' | API env - 'prod', 'staging', 'dev'|


<details>
	  <summary><b>Expected response (create space)</b></summary>

	```typescript
	// PushAPI.space.create | Response - 200 OK
	{
		members: [{
			wallet: 'eip155:0x727C819feB2c7F99c66d71B8411521bca2010023',
			publicKey: '-----BEGIN PGP PUBLIC KEY BLOCK-----\n' +
				'\n' +
				'xsBNBGSrssEBCACg3ZjrZB40Xqr5IKIEtFldaeQyJPNwDACMekY77yApav0B\n' +
				'RwiqhFJDFJKcprSHg/vYdqalAIGRQ+J98VMBtHweurIubD/ODB6WknOms7ZY\n' +
				'3ummaEzyFRombuq/C75o/0ImCi2v0PJBI3kdpwzOjiTt8S44yoAVOcTf9jyg\n' +
				'vTEVCOM81yqCf0mDB4t0jqRYewlQuJegORXDKHKTfZcnQybBkDYUGgmxOcyF\n' +
				'BaPMhSiWqAAqqb4gcFO2QKq69JoiE9dzSuF/7dvAq2QZRogC/GQW2Q9yQbq3\n' +
				'CvMNO4H2KUZzegaq2s2nMPGMXPNf4GZcZVJE1phWgAnApxTf5kUFfKr1ABEB\n' +
				'AAHNAMLAigQQAQgAPgWCZKuywQQLCQcICZDwrCS5ulOLwQMVCAoEFgACAQIZ\n' +
				'AQKbAwIeARYhBFKpO7zcSRed+QmbIfCsJLm6U4vBAABZMwf+OIbBcFQ7x++1\n' +
				'NINOYbP9v0PyJvpllDcUORbk3uiPMpvDuQYAe2Fd4dY2Y91l3VdpIm/w6HQy\n' +
				'y81Y694w4E7PRVhDwHivv5D10VE9MF3h6qOHrLLpvdhpMaB5Ur8ts5rU2zOu\n' +
				'64HR04/BVO9N0nrE9iywIgVMOy6IrS+OgK3r75PPX35bam/kbbmZHeygFaE9\n' +
				'+mgQVdhwgF5borekIiz1Rc8CPA/P1yZy8QQl4KGmJEs+hOc5rPnUWwarvaAH\n' +
				'mPb6H0/mG81eXBOjpJlSFu6d/uqKLpoAw5fkvFoIsNwovYpyQkSbhzwe4T2N\n' +
				'jGqGd0+La03QdB5FbaiwcnJ96lU6oM7ATQRkq7LBAQgAxu9uK1+p62+/RvcF\n' +
				'Mz7g3A8SJiN76NYxk29sjQ9gW74B/IdPv5TlUVhG6PGr2c3SucASlEHieagY\n' +
				'CXM2+fpdu4rQ6EKRAe+30GFopfzhX1d0zv9d5BE6q1ML5mkrpDECH5iuqah7\n' +
				'smmbRdWE7zRSGaHyEfVqAG3wfMzzN0BcchxxR4vMCNKYLs9v2Q09ecO7DgaY\n' +
				'5CZqxaFlTo+auuDhE0XU7WRbNL77izocV1Sm+McRyo28PrFTcrRRznD1nP0V\n' +
				'eZ4+aoulqyYA+gBBaIUdSA5kQXJiy67crB50yX3V6zLIfptD2ThHPjTY/inW\n' +
				'wVHVug4jIWUQ1QQw/q9qvGxAzQARAQABwsB2BBgBCAAqBYJkq7LBCZDwrCS5\n' +
				'ulOLwQKbDBYhBFKpO7zcSRed+QmbIfCsJLm6U4vBAADu6wf+NJDX/3NAxQKN\n' +
				'Iigj0GkBm/y69iFmQvWJxxtiYCNu8VBhm8MkcghUJ8G2tWP9ueUOM8sMTEa+\n' +
				'G+l+wSNwh/1yisF3FutDpy6l+fiy6kPPD4vl08jY3GrqSuWWfMxTJhMZ5D6v\n' +
				'OW2EfdyET+oP5eOnCd6p0EXP2ic48rVHDdU2iWeg0RkGvZP3t2LljWFdLbvw\n' +
				'h7+wSD1i4LY4slUIdbLdDSLN1gWFN1HXzX10mpX0grV2sBdfkNyHhF0WcIat\n' +
				'sD9HpAx2M62yP2D9D9UZVrW7WfmOoyL1NrnXSJsI8CRFDzujvpIrr7875zSi\n' +
				'VnxDVyt7twc7cYqRDHsNYuxAuE815A==\n' +
				'=2jvb\n' +
				'-----END PGP PUBLIC KEY BLOCK-----\n',
			isSpeaker: true,
			image: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA4klEQVR4AcXBoW3FMBRA0dsn75E9skAU6BkMSk1CA0xNsoBnMLSyQPbIDgVlLX0OcPX1Vb1zPj6/v35QWg5o61bQok+MHHVHazmgrVtBE4wJxgRjjofzmuj4xCuiT2iRCe2gJxgTjAnGXMuBTi2MRJ8YOerOSMsBTTAmGBOMuXUraNEntKPuaEfdeUX0iU4taIIxwZhgzPGH6BP/STAmGBOMOR6W+UY7r4l3LPONttITjAnGBGMu+kSnFrQlB96xbgUt+oQmGBOMCcYcDy0HRs5rYmSZb7SWA1pkQhOMCcYEY78uSjTZAXCkaQAAAABJRU5ErkJggg=='
		}],
		pendingMembers: [{
				wallet: 'eip155:0x5f4e9e7Fcc17a943178c0b0881b09E8Ef9D34437',
				publicKey: null,
				isSpeaker: false,
				image: null
			},
			{
				wallet: 'eip155:0xFedfA2b276676C5c6ce753ddb4B05d00104E9236',
				publicKey: null,
				isSpeaker: false,
				image: null
			}
		],
	  contractAddressERC20: "0x8Afa8FDf9fB545C8412499E8532C958086608b30",
	  numberOfERC20: 20,
	  contractAddressNFT: "0x42af3147f17239341477113484752D5D3dda997B",
	  numberOfNFTTokens: 2,
		verificationProof: 'pgp:-----BEGIN PGP SIGNATURE-----\n' +
			'\n' +
			'wsBzBAEBCAAnBYJkq7LBCZDwrCS5ulOLwRYhBFKpO7zcSRed+QmbIfCsJLm6\n' +
			'U4vBAAAAHwf+K4f0gxaP56X4Cv2zlPWB9iUPi/1FOnx8ZF7oEf9xJSv/xA7v\n' +
			'9LHBTZ2Y9AQlJpy0WLB7KGF7mVV1MdUKHjn2SFQ+1h+8d+FIHXfmB7Ie4alP\n' +
			'nnar6XjtMVKYyqXRzMzCq2F7Fjea1sUOXBxAeyJstAGG6nvsU51imaAtGQlQ\n' +
			'u7ih8D9UkiOe719v5GyI1vtiS+hHGlYo0+A7WVImH6SuVyPZ3UyPvLxXpeKs\n' +
			'1SeEfuvfmKHbswm1DDGOknyo7fJ/QgKqOfkwsBIrYRNGwPGEKt8pHdwNxsNn\n' +
			'hNQtlFqtmtvieaxbhJQKXHbVgNv206xNsUBrK/U2nCakx7EMmxikFg==\n' +
			'=tz9T\n' +
			'-----END PGP SIGNATURE-----\n',
		spaceImage: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAvklEQVR4AcXBsW2FMBiF0Y8r3GQb6jeBxRauYRpo4yGQkMd4A7kg7Z/GUfSKe8703fKDkTATZsJsrr0RlZSJ9r4RLayMvLmJjnQS1d6IhJkwE2bT13U/DBzp5BN73xgRZsJMmM1HOolqb/yWiWpvjJSUiRZWopIykTATZsJs5g+1N6KSMiO1N/5DmAkzYTa9Lh6MhJkwE2ZzSZlo7xvRwson3txERzqJhJkwE2bT6+JhoKTMJ2pvjAgzYSbMfgDlXixqjH6gRgAAAABJRU5ErkJggg==',
		spaceName: 'wasteful_indigo_warbler',
		isPublic: true,
		spaceDescription: 'boring_emerald_gamefowl',
		spaceCreator: 'eip155:0x727C819feB2c7F99c66d71B8411521bca2010023',
		spaceId: 'spaces:e0553610da88dacac70b406d1222a6881c0bde2c5129e58b526b5ae729d82116',
		scheduleAt: '2023-07-15T14:48:00.000Z',
		scheduleEnd: '2023-07-15T15:48:00.000Z',
		status: 'PENDING',
	}


	```

</details>

---

# Trending Spaces
```dart
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

void testTrendingSpace() async {
  final result = await push.trending();

  print(result);
}
```
<details>
<summary><b> Expected response</b></summary>

```javascript
{
    "spaces": [
        {
            "spaceId": "spaces:62dada77ab5ef7ea8a0f28232bcda400a18d870596fbc08f751888da2ca1861a",
            "about": null,
            "did": null,
            "intent": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentSentBy": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentTimestamp": "2023-08-23T19:25:58.000Z",
            "publicKey": null,
            "profilePicture": null,
            "threadhash": null,
            "wallets": null,
            "combinedDID": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723_eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280_eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
            "name": null,
            "spaceInformation": {
                "members": [
                    {
                        "wallet": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "pendingMembers": [
                    {
                        "wallet": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGSQEA4BCADe5R3VcGo8buNLBrcTDVBNkVjJJjpTla+03KbDTm4t6udP\nqsIjiU+PrxIt+60cmSZ3JQ2DxfWZ38HnP2UpTz6RNSaSfIT40ASjwbY3ab7Y\n0mmDjllPZwP96FkJb4OZJjBpDiCS/8K0NLCVP5AkrlQLjM5W096uQEdy65WG\nGLrY9AXMdv7186MxyK8HFaQA1t7S7c2F0WO6eYvj87gfHyyHa9AU9oSp23IU\n7N9iJPYjJdZprQ3ZZzSL6aTXo5V7Udw33ISA692Jd37rxIyebCN89uQ4aSQs\ncDGaZGTEVmuac7g81JWFWmI2n5CjMmM6Dmx5RFGdB7USKYpVYuF5pylJABEB\nAAHNAMLAigQQAQgAPgWCZJAQDgQLCQcICZCyBAli/0DNjwMVCAoEFgACAQIZ\nAQKbAwIeARYhBDReJpQl73RXyYMLprIECWL/QM2PAAAotQf/XKGcft9VgKI+\n+ypC3lH6loIYDaJ2oi4aWiUDXv8SSZINzlBIVp2mRQ/BDnCjlxsUUg8IRkr0\nFshgPvdWHHKgRpW1/nOG4j2Gz+jAgMCa6Y8kGuWBcik1Y8wIH1wlSBSTRNmw\n96HHh2U8zlt5l/baU02Eb9qXxbMpWXBTwudgFuLn/M1tseLiS/rXQCUmRuM2\nFTG07myDlf5cVZbrSWj2z3e9dmcGZsL9lHnBWTFSLkqLj2Yiou+5c43Sbrk7\njA9GyfpEbdhktq9QXn437NgjCHuk2anJDHkyenKFgdG6RKGWrYL6p2ybb60n\nP3R+VsIsUnkUFc6QhGBYDFXC9YKKcc7ATQRkkBAOAQgAg4P93v6FOhM8RYKm\nCXhnJBXAHoBAFg8mfTd9IHIheuwR1ljfpBwDhx2s28nNs4C2fpr2xFab5knS\nLqplM2OdaYY2Vc8viYHOyrZHY03Y73Rs26udX0LMQnRRfzglUwXEW4SfkC3i\n9qwdFOMcKk+OW8o2p5cHg6EOrG5eXwkvsIV9jUqWgZRfne+vWe/X5Gd+DAiR\nZxkw8eEbeaIRimWSbRWrWesfDf9U0XO5KsvDwk++3oyGWRKcuvQiIjDzNVt6\nKf+MlSjoIULwmP9BspveXy7NcYqgveaEXbrhrhGnhZFHnDi+JyB14qzKUqdG\n8dG8Xw4XFdr+MR5j276bROwwNQARAQABwsB2BBgBCAAqBYJkkBAOCZCyBAli\n/0DNjwKbDBYhBDReJpQl73RXyYMLprIECWL/QM2PAACiqAgAw77yAReVjee6\n3CSvbgoDx8SoGIbAzgbsEK5qDQeNQ0FtkPI6za/8NZAIQYAYS+tMt1ryOTSg\nkqHtILY6dnXxp4nbPdjPhxrdTrdtNqw+uLXOKoheFCBn8g9xeQwVnPUggXAA\ncw7QnJArXjO2pauWR81Ls8qd1m972hgntytuB5o5Note9jr0aM78ao4qCAM0\nLEz9eAV8rW43AkqksgX6FYamjO5wqfkbPm3H11k6baxuYccrzUwk/wOCe1ve\nfPAaeubF5c7gOFsfATaZO4dtf82od7gc2Bc5CXh3fajIOOc0vszTJA27m+AR\nCbb7ukweAenQkckz5bbExQRLnKE+0A==\n=qX2W\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": false,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA00lEQVR4AcXBsU1DUQxA0Yv1JAags34mcE/JUB7Ei2SLlOnd0oDcZQZoHYqHohQ+58U/X394gKeyE1Y8QhgmDBOGLf7hqXTn28GOJ3fCih1hmDBMGLY8lZ2wovNkK6zoPJUdYZgwTBi2woodT6ULK3Y8lS6s2BGGCcOEYctT6cKKHU/lGZ5KJwwThgnDVljReSpdWNF5KjthReepdGFFJwwThgnD1unyTnfmr6ILKx5xvh10p8tBJwwThgnD1tfHlc5TuZPKU96+6cKKThgmDBOG/QKNNziryDuzmQAAAABJRU5ErkJggg=="
                    },
                    {
                        "wallet": "eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "contractAddressERC20": null,
                "numberOfERC20": 0,
                "contractAddressNFT": null,
                "numberOfNFTTokens": 0,
                "verificationProof": "pgp:-----BEGIN PGP SIGNATURE-----\n\nwsBzBAABCAAnBQJk5g/sCZA7/jxKMDdVgxYhBJco5U6B/S5LNkspyzv+PEowN1WD\nAADY+QgAnHYU16QjYWugTbU2zfFYP+DVvSDhW3FgWLxE/CzpR/RQ9ohmBx/I73C0\nfrFFPJMmaLi+KEYiAFHgO3cq9nZzHpuUy7qccADxk9pnWA234V05i7oYVkXdLZTj\nNiuUYdHQ0RnHiWhuiPfaPzEm4M1YWd16d0eqZdl4cLCrL4UcCO1WzjckitEpHH2O\n9pQD7oOrXVcy7z9dJaZ5MI7r9GWbejbVbBhX9ioShaDoYNIrAE4SmNNo3mFUqgFh\nOVyIenboBO6V0nibvys6OhI2M9rmf4N423d/64iuV6+Qz/93z/cozR+ixK4ranwg\nsH3Jqt6tLoCiCxC22f7BrpsE2PtVJw==\n=0PcM\n-----END PGP SIGNATURE-----",
                "spaceImage": "asdads",
                "spaceName": "Testing dart - 123567810123",
                "isPublic": true,
                "spaceDescription": "Testing dart",
                "spaceCreator": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                "spaceId": "spaces:62dada77ab5ef7ea8a0f28232bcda400a18d870596fbc08f751888da2ca1861a",
                "meta": null,
                "scheduleAt": "2024-03-31T00:00:00.000Z",
                "scheduleEnd": null,
                "status": "PENDING",
                "rules": {}
            }
        },
        {
            "spaceId": "spaces:8b67e0b3898bd7d3665cb398edf873895f7851b9b6a5104f688c0e8b15fe5268",
            "about": null,
            "did": null,
            "intent": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentSentBy": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentTimestamp": "2023-08-02T22:26:55.000Z",
            "publicKey": null,
            "profilePicture": null,
            "threadhash": null,
            "wallets": null,
            "combinedDID": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723_eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280_eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
            "name": null,
            "spaceInformation": {
                "members": [
                    {
                        "wallet": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "pendingMembers": [
                    {
                        "wallet": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGSQEA4BCADe5R3VcGo8buNLBrcTDVBNkVjJJjpTla+03KbDTm4t6udP\nqsIjiU+PrxIt+60cmSZ3JQ2DxfWZ38HnP2UpTz6RNSaSfIT40ASjwbY3ab7Y\n0mmDjllPZwP96FkJb4OZJjBpDiCS/8K0NLCVP5AkrlQLjM5W096uQEdy65WG\nGLrY9AXMdv7186MxyK8HFaQA1t7S7c2F0WO6eYvj87gfHyyHa9AU9oSp23IU\n7N9iJPYjJdZprQ3ZZzSL6aTXo5V7Udw33ISA692Jd37rxIyebCN89uQ4aSQs\ncDGaZGTEVmuac7g81JWFWmI2n5CjMmM6Dmx5RFGdB7USKYpVYuF5pylJABEB\nAAHNAMLAigQQAQgAPgWCZJAQDgQLCQcICZCyBAli/0DNjwMVCAoEFgACAQIZ\nAQKbAwIeARYhBDReJpQl73RXyYMLprIECWL/QM2PAAAotQf/XKGcft9VgKI+\n+ypC3lH6loIYDaJ2oi4aWiUDXv8SSZINzlBIVp2mRQ/BDnCjlxsUUg8IRkr0\nFshgPvdWHHKgRpW1/nOG4j2Gz+jAgMCa6Y8kGuWBcik1Y8wIH1wlSBSTRNmw\n96HHh2U8zlt5l/baU02Eb9qXxbMpWXBTwudgFuLn/M1tseLiS/rXQCUmRuM2\nFTG07myDlf5cVZbrSWj2z3e9dmcGZsL9lHnBWTFSLkqLj2Yiou+5c43Sbrk7\njA9GyfpEbdhktq9QXn437NgjCHuk2anJDHkyenKFgdG6RKGWrYL6p2ybb60n\nP3R+VsIsUnkUFc6QhGBYDFXC9YKKcc7ATQRkkBAOAQgAg4P93v6FOhM8RYKm\nCXhnJBXAHoBAFg8mfTd9IHIheuwR1ljfpBwDhx2s28nNs4C2fpr2xFab5knS\nLqplM2OdaYY2Vc8viYHOyrZHY03Y73Rs26udX0LMQnRRfzglUwXEW4SfkC3i\n9qwdFOMcKk+OW8o2p5cHg6EOrG5eXwkvsIV9jUqWgZRfne+vWe/X5Gd+DAiR\nZxkw8eEbeaIRimWSbRWrWesfDf9U0XO5KsvDwk++3oyGWRKcuvQiIjDzNVt6\nKf+MlSjoIULwmP9BspveXy7NcYqgveaEXbrhrhGnhZFHnDi+JyB14qzKUqdG\n8dG8Xw4XFdr+MR5j276bROwwNQARAQABwsB2BBgBCAAqBYJkkBAOCZCyBAli\n/0DNjwKbDBYhBDReJpQl73RXyYMLprIECWL/QM2PAACiqAgAw77yAReVjee6\n3CSvbgoDx8SoGIbAzgbsEK5qDQeNQ0FtkPI6za/8NZAIQYAYS+tMt1ryOTSg\nkqHtILY6dnXxp4nbPdjPhxrdTrdtNqw+uLXOKoheFCBn8g9xeQwVnPUggXAA\ncw7QnJArXjO2pauWR81Ls8qd1m972hgntytuB5o5Note9jr0aM78ao4qCAM0\nLEz9eAV8rW43AkqksgX6FYamjO5wqfkbPm3H11k6baxuYccrzUwk/wOCe1ve\nfPAaeubF5c7gOFsfATaZO4dtf82od7gc2Bc5CXh3fajIOOc0vszTJA27m+AR\nCbb7ukweAenQkckz5bbExQRLnKE+0A==\n=qX2W\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": false,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA00lEQVR4AcXBsU1DUQxA0Yv1JAags34mcE/JUB7Ei2SLlOnd0oDcZQZoHYqHohQ+58U/X394gKeyE1Y8QhgmDBOGLf7hqXTn28GOJ3fCih1hmDBMGLY8lZ2wovNkK6zoPJUdYZgwTBi2woodT6ULK3Y8lS6s2BGGCcOEYctT6cKKHU/lGZ5KJwwThgnDVljReSpdWNF5KjthReepdGFFJwwThgnD1unyTnfmr6ILKx5xvh10p8tBJwwThgnD1tfHlc5TuZPKU96+6cKKThgmDBOG/QKNNziryDuzmQAAAABJRU5ErkJggg=="
                    },
                    {
                        "wallet": "eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "contractAddressERC20": null,
                "numberOfERC20": 0,
                "contractAddressNFT": null,
                "numberOfNFTTokens": 0,
                "verificationProof": "pgp:-----BEGIN PGP SIGNATURE-----\n\nwsBzBAABCAAnBQJkyorVCZA7/jxKMDdVgxYhBJco5U6B/S5LNkspyzv+PEowN1WD\nAACTiwf+KuSWPXmGG7mIjDsZc0kDUkvkNW0gE/jAUWDl+nGbBL7H9QpNBWApt0W3\nXY4LE0oxYJMq5i7GRCh+ydzXRX//dTObB/Aam+LtfNQ1EI8UVwhCe06lW97Uq81x\nVoo3L73fuq7chvW7oJCE4P9v4CXz4/cEdUe0SRf6kd5jNwvvJHUMOOU/dE9ud5iQ\n0BHielCuOaLPKShPbXyCRYEFY+fLvFFhpDHm8nq4xPIKyX8xTqYpj4iXvwZqtFcZ\nBxJ1aGeLPvWNOBpnJ06K0nWfIH+p5Z04vCYZpi8VQJsZzDJsSYJCviJwxxjSNEEA\nfV9T9uuBtAxfaqXQg+Bdm4Jyl1s6iA==\n=okxN\n-----END PGP SIGNATURE-----",
                "spaceImage": "asdads",
                "spaceName": "Testing dart - 123567810123",
                "isPublic": true,
                "spaceDescription": "Testing dart",
                "spaceCreator": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                "spaceId": "spaces:8b67e0b3898bd7d3665cb398edf873895f7851b9b6a5104f688c0e8b15fe5268",
                "meta": "abcd",
                "scheduleAt": "2024-03-31T00:00:00.000Z",
                "scheduleEnd": null,
                "status": "PENDING",
                "rules": {}
            }
        }
    ]
}
```
</details>

---

# Space Feeds
```dart
import 'package:push_restapi_dart/push_restapi_dart.dart' as push;

void testSpaceFeeds() async {
  final result = await push.spaceFeeds(
    
  );

  print(result);
  if (result is List<push.SpaceFeeds>) {
    
  }
}
```

<details>
<summary><b>Expected Response</b> </summary>

```typescript
{
    "spaces": [
        {
            "spaceId": "spaces:62dada77ab5ef7ea8a0f28232bcda400a18d870596fbc08f751888da2ca1861a",
            "about": null,
            "did": null,
            "intent": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentSentBy": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
            "intentTimestamp": "2023-08-23T19:25:58.000Z",
            "publicKey": null,
            "profilePicture": null,
            "threadhash": null,
            "wallets": null,
            "combinedDID": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723_eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280_eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
            "name": null,
            "spaceInformation": {
                "members": [
                    {
                        "wallet": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "pendingMembers": [
                    {
                        "wallet": "eip155:0x9960D6B63B113303B9910A03ca5341B83CC52723",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGSQEA4BCADe5R3VcGo8buNLBrcTDVBNkVjJJjpTla+03KbDTm4t6udP\nqsIjiU+PrxIt+60cmSZ3JQ2DxfWZ38HnP2UpTz6RNSaSfIT40ASjwbY3ab7Y\n0mmDjllPZwP96FkJb4OZJjBpDiCS/8K0NLCVP5AkrlQLjM5W096uQEdy65WG\nGLrY9AXMdv7186MxyK8HFaQA1t7S7c2F0WO6eYvj87gfHyyHa9AU9oSp23IU\n7N9iJPYjJdZprQ3ZZzSL6aTXo5V7Udw33ISA692Jd37rxIyebCN89uQ4aSQs\ncDGaZGTEVmuac7g81JWFWmI2n5CjMmM6Dmx5RFGdB7USKYpVYuF5pylJABEB\nAAHNAMLAigQQAQgAPgWCZJAQDgQLCQcICZCyBAli/0DNjwMVCAoEFgACAQIZ\nAQKbAwIeARYhBDReJpQl73RXyYMLprIECWL/QM2PAAAotQf/XKGcft9VgKI+\n+ypC3lH6loIYDaJ2oi4aWiUDXv8SSZINzlBIVp2mRQ/BDnCjlxsUUg8IRkr0\nFshgPvdWHHKgRpW1/nOG4j2Gz+jAgMCa6Y8kGuWBcik1Y8wIH1wlSBSTRNmw\n96HHh2U8zlt5l/baU02Eb9qXxbMpWXBTwudgFuLn/M1tseLiS/rXQCUmRuM2\nFTG07myDlf5cVZbrSWj2z3e9dmcGZsL9lHnBWTFSLkqLj2Yiou+5c43Sbrk7\njA9GyfpEbdhktq9QXn437NgjCHuk2anJDHkyenKFgdG6RKGWrYL6p2ybb60n\nP3R+VsIsUnkUFc6QhGBYDFXC9YKKcc7ATQRkkBAOAQgAg4P93v6FOhM8RYKm\nCXhnJBXAHoBAFg8mfTd9IHIheuwR1ljfpBwDhx2s28nNs4C2fpr2xFab5knS\nLqplM2OdaYY2Vc8viYHOyrZHY03Y73Rs26udX0LMQnRRfzglUwXEW4SfkC3i\n9qwdFOMcKk+OW8o2p5cHg6EOrG5eXwkvsIV9jUqWgZRfne+vWe/X5Gd+DAiR\nZxkw8eEbeaIRimWSbRWrWesfDf9U0XO5KsvDwk++3oyGWRKcuvQiIjDzNVt6\nKf+MlSjoIULwmP9BspveXy7NcYqgveaEXbrhrhGnhZFHnDi+JyB14qzKUqdG\n8dG8Xw4XFdr+MR5j276bROwwNQARAQABwsB2BBgBCAAqBYJkkBAOCZCyBAli\n/0DNjwKbDBYhBDReJpQl73RXyYMLprIECWL/QM2PAACiqAgAw77yAReVjee6\n3CSvbgoDx8SoGIbAzgbsEK5qDQeNQ0FtkPI6za/8NZAIQYAYS+tMt1ryOTSg\nkqHtILY6dnXxp4nbPdjPhxrdTrdtNqw+uLXOKoheFCBn8g9xeQwVnPUggXAA\ncw7QnJArXjO2pauWR81Ls8qd1m972hgntytuB5o5Note9jr0aM78ao4qCAM0\nLEz9eAV8rW43AkqksgX6FYamjO5wqfkbPm3H11k6baxuYccrzUwk/wOCe1ve\nfPAaeubF5c7gOFsfATaZO4dtf82od7gc2Bc5CXh3fajIOOc0vszTJA27m+AR\nCbb7ukweAenQkckz5bbExQRLnKE+0A==\n=qX2W\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": false,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA00lEQVR4AcXBsU1DUQxA0Yv1JAags34mcE/JUB7Ei2SLlOnd0oDcZQZoHYqHohQ+58U/X394gKeyE1Y8QhgmDBOGLf7hqXTn28GOJ3fCih1hmDBMGLY8lZ2wovNkK6zoPJUdYZgwTBi2woodT6ULK3Y8lS6s2BGGCcOEYctT6cKKHU/lGZ5KJwwThgnDVljReSpdWNF5KjthReepdGFFJwwThgnD1unyTnfmr6ILKx5xvh10p8tBJwwThgnD1tfHlc5TuZPKU96+6cKKThgmDBOG/QKNNziryDuzmQAAAABJRU5ErkJggg=="
                    },
                    {
                        "wallet": "eip155:0xffa1af9e558b68bbc09ad74058331c100c135280",
                        "publicKey": "-----BEGIN PGP PUBLIC KEY BLOCK-----\n\nxsBNBGN/K/kBCADEv8v4k/rWXEhF47geWz1UBySLtgsCZxZK7RPhLWecku6N\nXTAPScS9YjXLDqy0tZ6nDvXh/vPbNNkd9phBGh5Mo6O3vNjI9pwd06KyT4sT\nChjenRXU+aLHQzjTXOMO1xHkN3yiuLqC8mZ/OBPBkjHhC00taqhuWWudfcEv\n5DqZPqtHBwOipvtEqR9BDnVO4srL0xZPksJVPBmcekll61obQylKGx1K8vTg\n292Ivo+tPpDSkXdxWTx4EmcOPw/7E4IRoUudkAZUJzgZL48UPR7oDox8JIgH\nyF4PMTvKZR0Fps+8W/USMO9Mc5AUwNqkmvQyywo8wdTIWW8ki9OPhWvjABEB\nAAHNAMLAigQQAQgAPgUCY38r+QQLCQcICRA7/jxKMDdVgwMVCAoEFgACAQIZ\nAQIbAwIeARYhBJco5U6B/S5LNkspyzv+PEowN1WDAAB4bQf9FIzCf5fmwKuw\ng2B2IV9LIo5zZHU0Wkm52n0kesEJGfYJu/ub/GhPBtoAr8Pf+5CkGN75kxWg\nEhKDy8Sm/L+50I1QhIk1x73LMUz2cIxJeJdHdI13t+lZrp5Ni01KiPJzB7LJ\n2Nj5d5Kf53sM6A/Q7fwwUprbwTh1aQzngf8KSups6AjqLQe2Qyu6LzVTKcXe\nvQyIoYHxBdcy+2hH0ZIkkKvcWHHqIuym4NJXLqxxhqpK20KpIfl+YufqJiSW\n+f+imCrQSslXLL2E3fS+bPORTU/aL/uPkW1645BPoFuWKr7S+bVrEnp0sCS9\nxH/COFWmxhoeHHcu5tqKGJdsUZ9iiM7ATQRjfyv5AQgAm5KRDtuUtvLLLOrm\ncQ0IcFEa00guCEKbZfYmX/OFHBooBy185SWTKDRKilLTxGosnNFQbDovrbDA\npP+DLDIHMBRJHnQCuCkXRqGV5vcI8VD3zOalUJpz6f+QKWnkhv2lt05OTeOc\nhhC7NCC3joe0rUtUgYpvv4i18BrrrADaY0Qkmy7RBor7CCXAttbeOhsxJc1E\n1b7bhJW1Ja8yezDCN7801S/GPjohpzEYkKkw+ziBDJnvXJC8T+hRINo0RtX9\n9xn2beUJSquDTw9Y2tvQ6RMMiYcjiSVQ6n9XqgRp6GDlY2JhGigmmd8+4cpZ\n2EH9kGrwGIGUH/D91owQejNiAwARAQABwsB2BBgBCAAqBQJjfyv5CRA7/jxK\nMDdVgwIbDBYhBJco5U6B/S5LNkspyzv+PEowN1WDAADewgf9EuYPp6eSjbK3\ntpDoUV6xTmGHi6R0+8szSF+1yJ3oGzxd60K9pz9eeSsjjUL9sasKWmVMaG2U\n99Pc0ZV1czl+nthzigsJIq1ZbTFWA2xcNLOWa5Qw7bnb8QcH7t+l6gW95whT\nlA9SL8mAzYHzKLyVlTfJD7bUZSWtk7DhNr8QCq9U5W6GoSM619zC5Ndcg0Av\nhwmPmsFjGxI6E/69f+ZpKmQ3xbMTLhzQZYT5wRyNDHh7KFYM6yfc8sg1+VSm\nFWgChvHKD9X+z4KyVTuxHwZVda17tYoHmUM+dF3JuzZJteTiAii9tu3oDRKW\n4QpEgIbbKge5JRntvBdRr714aPjztA==\n=aP07\n-----END PGP PUBLIC KEY BLOCK-----\n",
                        "isSpeaker": true,
                        "image": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAA6ElEQVR4AcXBoXEDMRRF0btvtglhMdcQ5jHfLhwiqiJ2wkRShhowSREiHoWqBqMN/TYQ8WT+Ocv9cTkwRolYIXWsUSIzIXWsUSJWSB1LOBPOhLPl++P3wDhtOzMhdWZGicy0mrGEM+FMOFt50WrGOm0772g1MyOcCWfC2XJ/XA4mRom8I6TOjHAmnAlnKy9GiVitZqzTtjPTaubZjhVSxxLOhDPhbPn5+jwwQurMjBKZCakzM0rEEs6EM+FsbTXzbMcKqWO1mpkJ6Yo1SsRqNWMJZ8KZcLaeb1esUSL/6Xy7Yglnwplw9gcz1UAzKe4AEAAAAABJRU5ErkJggg=="
                    }
                ],
                "contractAddressERC20": null,
                "numberOfERC20": 0,
                "contractAddressNFT": null,
                "numberOfNFTTokens": 0,
                "verificationProof": "pgp:-----BEGIN PGP SIGNATURE-----\n\nwsBzBAABCAAnBQJk5g/sCZA7/jxKMDdVgxYhBJco5U6B/S5LNkspyzv+PEowN1WD\nAADY+QgAnHYU16QjYWugTbU2zfFYP+DVvSDhW3FgWLxE/CzpR/RQ9ohmBx/I73C0\nfrFFPJMmaLi+KEYiAFHgO3cq9nZzHpuUy7qccADxk9pnWA234V05i7oYVkXdLZTj\nNiuUYdHQ0RnHiWhuiPfaPzEm4M1YWd16d0eqZdl4cLCrL4UcCO1WzjckitEpHH2O\n9pQD7oOrXVcy7z9dJaZ5MI7r9GWbejbVbBhX9ioShaDoYNIrAE4SmNNo3mFUqgFh\nOVyIenboBO6V0nibvys6OhI2M9rmf4N423d/64iuV6+Qz/93z/cozR+ixK4ranwg\nsH3Jqt6tLoCiCxC22f7BrpsE2PtVJw==\n=0PcM\n-----END PGP SIGNATURE-----",
                "spaceImage": "asdads",
                "spaceName": "Testing dart - 123567810123",
                "isPublic": true,
                "spaceDescription": "Testing dart",
                "spaceCreator": "eip155:0xfFA1aF9E558B68bBC09ad74058331c100C135280",
                "spaceId": "spaces:62dada77ab5ef7ea8a0f28232bcda400a18d870596fbc08f751888da2ca1861a",
                "meta": null,
                "scheduleAt": "2024-03-31T00:00:00.000Z",
                "scheduleEnd": null,
                "status": "PENDING",
                "rules": {}
            }
        }
    ]
}
```
</details>