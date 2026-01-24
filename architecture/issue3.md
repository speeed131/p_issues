# 課題

> PersonクラスとCompanyクラスが存在するとします。Personクラスの名前と勤務開始日（name, starWorkingAt）は外部から自由に書き換えられるような状態になっています。この設計にはどのような問題が潜んでいるでしょうか？どうすれば解決できると思いますか？ 同じ課題を渡された新人エンジニアが「わかりました！getterとsetterを定義すれば良いんですね！」と言ってきました。なぜそれが問題を解決していないのか教えてあげましょう

- Person や Companyのプロパティが外部で自由に代入できるミュータブルなので、簡単に値を破壊できてしまう
- getter / setter でも値を変更できてしまう。
  - 以下のようにカプセル化して参照を渡さないようにする

```ts
  get startWorkingAt() {
    return new Date(this.startWorkingAt.getTime())
  }
```
