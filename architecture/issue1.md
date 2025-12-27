## 課題1-1

> SOLID原則の各要素を、業務経験1年目のITエンジニアに伝わるように説明してください。これらを守ることで、どのようなメリットがあるのでしょうか？

S: Single Responsibility Principle（単一責任の原則）

- 1つのクラス/関数は、1つの役割だけを持つ
- 修正の理由が1つになるので、変更時に影響範囲が狭くなる
以下のように役割がきちんと分かれている

```ts
async function registerUser(req) {
  // バリデーション
  validateRegisterInput(input)
  // パスワードハッシュ
  hashPassword(password) 
  // DB保存
   saveUser(user) 

}
```

O: Open/Closed Principle（開放/閉鎖の原則）

- クラスや関数は変更には閉じ、拡張には開く
- NG例のように割引ルール増えるたびに既存関数の修正が必要になるものではなく、OK例のように既存関数の修正は必要なくなるもの

```ts
// NG例
function calcTotal(price: number, discountType: "none" | "new" | "bf") {
  if (discountType === "new") return price * 0.9;
  if (discountType === "bf") return price * 0.7;
  return price;
}

// OK例
type Discount = (price: number) => number;

const noDiscount: Discount = (p) => p;
const newUser: Discount = (p) => p * 0.9;
const blackFriday: Discount = (p) => p * 0.7;

function calcTotal(price: number, discount: Discount) {
  return discount(price);
}

calcTotal(1000, noDiscount);   // 1000
calcTotal(1000, newUser);      // 900
```

L: Liskov Substitution Principle（リスコフの置換原則）

- 子クラス（派生）は、親クラス（基底）の代わりに当然のように使える
- 例として、Bird クラスに fly() があるのに、Penguin extends Bird が fly() で例外投げる
- 置換できる設計にすると、安心して差し替えできる

I: Interface Segregation Principle（インターフェース分離の原則）

- クライアントが使用しないインターフェースを混ぜない。必要なものだけ小さく分ける。
- 例のように必要な引数だけ渡すインターフェースにする

```ts
//NG例
function formatPrice(price, ctx) {
  // ctx: locale, currency, user, logger, db, ...
}

//OK例
function formatPrice(price: number, locale: string, currency: string) {
  // price, locale, currency のみ
}


```

D: Dependency Inversion Principle（依存性逆転の原則）

- 具体（実装）ではなく、抽象（インターフェース）に依存することで、上位のロジックが、下位の詳細に引きずられないようにする
- 詳細が変わっても、上位ロジックを大きく変えずに済む
- 例のように、依存を引数で受け取る

```ts
type FetchJson = (url: string) => Promise<any>;

async function getUserName(userId: string, fetchJson: FetchJson) {
  const user = await fetchJson(`/api/users/${userId}`);
  return user.name;
}
```

SOLID原則によって、変更に強い、読みやすい、バグが出にくい、テストしやすいコードを書くことができる

## 課題1-2

> 単一責任の原則と、単純にファイルを細かなファイルに分解することには、どのような違いがあるでしょうか？

単一責任の原則では、責任・役割で分けるが、単純なファイル分割ではその意味をなしていない。
責任で分割ができていないケースでは、逆に、変更に対して全てのファイル修正が必要になるなど悪くなるケースもある。

## 課題1-3

1-1で書いているため割愛

## 課題1-4

> リスコフの置換原則に違反した場合、どのような不都合が生じるでしょうか？

呼び出し側のコードで特別対応しなければならなくなり、新しい子クラスを追加するたびに呼び出し側も修正が必要になる。それによって、変更箇所が増える（修正漏れが起きる）、可読性が落ちるなど。

## 課題1-5

> インターフェースを用いる事で、設計上どのようなメリットがあるでしょうか？

- 実装の差し替えが簡単にできる
- テストのモック/スタブ差し替えができる
- インターフェースによって上位のロジック（業務ロジックなど）が下位（DBや外部APIの詳細）に引きずられず、影響範囲が境界で止まる
- 役割がインターフェースによってわかりやすい
- インターフェースによって使う側が知る必要ない詳細/実装を隠蔽できる

## 課題1-6

> どんな時に依存性の逆転を用いる必要が生じるのでしょうか？

- 外部依存が絡んでいるとき
- 実装の入れ替えが起きそう（or 起きた）とき
  - SDKやDBなど
- 「ビジネスルール」と「技術詳細」が混ざってきたとき
  - 例外処理やリトライ、ログ、リクエスト整形が混ざっていて複雑になっているなど
- 呼び出し側で分岐（if/instanceof）が増え始めたとき
    -上位が具体実装を知らなければいけなくなっている

## 課題1-7-1

> デメテルの法則とは何でしょうか？業務経験1年目のITエンジニアに伝わるように説明してください。この法則を守ることで、どのようなメリットがあるのでしょうか？

任意のオブジェクトが自分以外（サブコンポーネント含む）の構造やプロパティに対して持っている仮定を最小限にすべきであること。

具体的には、
`const zip = order.getUser().getAddress().getZipCode();` のように
orderがuserというプロパティを持ち、userがadressというプロパティを持ち、adressがzipCodeというプロパティを持つということを知っている必要がある。
上記によって、

- 変更に弱くなる
  - order.getUser().getAddress() の構造が変わったら、呼び出し側の変更が必要になる
    - こういう変更が入るたびに、利用箇所を全部探して直す必要がある

- 依存が増えて、コードの意図が読みにくくなる
    -order を扱ってるのに、User や Address の事情まで呼び出し側が知る必要がある

よって守ることのメリットとして、変更に強い、可読性が高い、テストしやすい設計になる。

## 課題1-7-2

以下保守性に対して効果がない理由

- getter / setter を定義してあげても、`purchase.user.id`や`purchase.product.id`と依存構造の実態は変わっていない。呼び出し元は相変わらず purchase.userId / purchase.productId に依存することになる。元々の公開フィールド（user, product）からgetter, setterに変わっただけである。
- setter があると不変性がなくなる、変更の追跡も難しくなる
