## 課題
>
> 例えば[このサンプルコード](https://www.typescriptlang.org/play?#code/JYOwLgpgTgZghgYwgAgAoFcoIBZwM4oDeAUMsugVAJIAmAXMnmFKAOanIAOUA9jegjC0GTFiHZlmcEHkRhgPEAxJkyeAUgg0tDZuggcyCHgFtOAGwiQaAQTAMAInEgcAvsXfFQkWIhSo4AE8TCHAAJQhjKBoIzh5kFWRWKwwsXAI8ACFAhgAKCmhhRmY2AEpkAF4APjRMHHwIAG0AXQ9iYgRzfDxatIaAZWgAN2AkBI5OdAAjc1HkYxk9QR4oXO5gIecUTiCQ8MiVmIg4hgDg0LAIqKO48sJPMkmZucm+gnzKItE2ABouXn4gi+JXEd0M80UTGQcHM5lS9QylWQYGwwDwADodud9tdYjx0ckwPD0hAsoEPoUaKVwQsoTsmMSGkiYXC6iSMTBQDRcmtytUuJiAQIhDRKhUKv8+MLaMgAGSygVSGRyBQgdHqBCabRU8HAGDINb4Ilshpg1SqFG8ADuyBAEBtAFEoLxVgByQDKDIA7BkAYqqAQZVAPYMgCkGQBODIALBkAUQyAVQZAH4MgAA5X2ABTTAFnagHMGQCaDIBAf9d1PND1UAHp88hAD8xgFNFQDSRoAs30AsgyAawZAEwJgACGNweIAhttps://www.typescriptlang.org/play?#code/JYOwLgpgTgZghgYwgAgAoFcoIBZwM4oDeAUMsugVAJIAmAXMnmFKAOanIAOUA9jegjANUvfoI7M4IPIjDAeIBiTJk8ApBBqaGzdBA5kEPALacANhEg0AgkOQAROJA4BfYm+KhIsRChF8BMGRlLlFA2gYmFhB2MhA4YwhI5jYOAjB-MTA8YTDBAG0AXXdiT3BoeCQ0OABPRPAAJQgjKBomzh5gjlZLDCxcAjwAIRqGAAoKaAjGFJiASmQAXgA+NEwcfAgikuIEM3w8Nf7NgGVoADdgKpDOdAAjMyvkI2ldQR4oMe5gc6cUTlq9TATRabQgHWEgIgjWaHzBHQWhA8ZFuDyet2OBAmlGmUTYABpQgFBLjZqxEQZngomMg4GYzH0NoMlsgwNhgHgAHQAurQ4Gw1rtHicnoZdYDCDDGrYqY0OalFS0+mMiVcmAfACiiGwYy+4s2CxWXUVZGAMGQesxEG5eTAnPSmUCXOMcE4us4htWnBtxLAtDmnNAe3QWjwX1t-opJpUbN4AHdkCAIAmNVBeJ8AOSAboZAMMMgAmGQBiqoBBlUASQyAH5jAKaKgAg7QD+DIA7BkAnaaAewZAIAMgGUGOvFkuAFQZK4ARBkA+gyAAwZAIoMgD8GQDaDIBkhkAgP8Z+XRtyKlzyykAejXyErgGkjQBZvoBZBkA1gyAJgTAAEMrncQA)では「特定の商品は1人につき年間1つまでしか買えない」といった仕様を実現しようとしています。このコードにはどのような問題点が潜んでいるでしょうか？もしあなたが書き換えるとしたら、どのようにこのコードを改修しますか？

## 課題点

- そもそも１年間で絞っていないので、その対応が必要
- 全購入履歴を取ってきて find しているため、getPurchasesBy が重くなる
  - 対応策: hasPurchased(userId, productId): boolean などで Repositoryに寄せて DB でexistsクエリにする
- 例外が呼び出し元でのハンドリングが難しくなりそう
  - 対応策: ユーザに向けてのエラーメッセージぽいが、この段階では他のエラーも含めて呼び出し側で制御しなくてはならなくなりそうなので、 class PurchaseNotAllowedError extends Error {} もしくは Result型などを使う。
- また、分岐におけるPurchase.transaction.succeeded が trueをしか返さないのであれば、分岐に入れる必要はなさそう

## 改善案

```ts
// 会員タイプ仮定義
type Membership = "normal" | "premium"

/**
 * 購入制限ルール
 */
class PurchaseLimitRule {
  /** 通常会員の制限期間（日数） */
  private static readonly LIMIT_DAYS_FOR_NORMAL = 365

  /**
   * 制限がないなら null、制限があるなら「日数」を返す。
   */
  static limitDays(membership: Membership): number | null {
    if (membership === "premium") return null
    return PurchaseLimitRule.LIMIT_DAYS_FOR_NORMAL
  }
}

interface PaymentRecordRepo {
  /**
   * since 以降の成功購入が存在するか
   */
  existsSuccessfulPurchase(params: {
    userId: string
    productId: string
    since: Date
  }): boolean
}

/**
 * 購入が許可されないことを示すドメインエラー
 */
class PurchaseNotAllowedError extends Error {
  constructor(public code: "LIMIT_PER_PERIOD") {
    super(code)
  }
}

/**
 * base, days を基準に日時を作成
 */
const daysAgoFrom = (base: Date, days: number) => {
  const d = new Date(base.getTime())
  d.setDate(d.getDate() - days)
  return d
}

/**
 * 期間内の再購入制限を検証し、違反なら例外を投げる
 */
const validatePurchaseLimit = ({
  repo,
  now,
  userId,
  productId,
  membership,
}: {
  repo: PaymentRecordRepo
  now: Date
  userId: string
  productId: string
  membership: Membership
}): void => {
  const limitDays = PurchaseLimitRule.limitDays(membership)
  if (limitDays === null) return

  const since = daysAgoFrom(now, limitDays)
  const alreadyPurchased = repo.existsSuccessfulPurchase({
    userId,
    productId,
    since,
  })

  if (alreadyPurchased) throw new PurchaseNotAllowedError("LIMIT_PER_PERIOD")
}

class PurchaseService {
  constructor(
    private repo: PaymentRecordRepo,
    private nowFn: () => Date = () => new Date()
  ) {}

  purchase(userId: string, productId: string, membership: Membership) {
    const now = this.nowFn()

    this.validate(userId, productId, membership, now)

    // 購入手続きへ
  }

  /**
   * 購入前の検証
   * 検証が増えた場合はこちらに追加
   */
  private validate(
    userId: string,
    productId: string,
    membership: Membership,
    now: Date
  ) {
    validatePurchaseLimit({
      repo: this.repo,
      now,
      userId,
      productId,
      membership,
    })
  }
}
```
