@Entry
@Component
struct LoginPage {
  @State phoneNumber: string = ''
  @State password: string = ''
  @State showPassword: boolean = false
  @State agreePolicy: boolean = false
  @State countryCode: string = '+86'

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景图片
      Image($r('app.media.icon_login_bg'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      Column() {
        // 标题
        Text($r('app.string.login_title'))
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .textAlign(TextAlign.Center)
          .width('100%')
          .margin({ top: 70, left: 30, right: 30 })

        Blank()

        // 登录表单
        Column({ space: 20 }) {
          // 手机号输入
          Column() {
            Row() {
              // 国家代码选择
              Row() {
                Text(this.countryCode)
                  .fontSize(14)
                  .fontColor('#333333')
                Image($r('app.media.icon_login_arrow_bottom'))
                  .width(30)
                  .height(30)
              }
              .onClick(() => {
                // 选择国家代码
              })

              Divider()
                .vertical(true)
                .height(15)
                .color('#d8d8d8')
                .strokeWidth(1)

              TextInput({ placeholder: $r('app.string.hint_name') })
                .type(InputType.PhoneNumber)
                .maxLength(20)
                .fontSize(14)
                .fontColor('#333333')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .padding({ left: 10 })
                .onChange((value: string) => {
                  this.phoneNumber = value
                })
            }
            .width('100%')
            .height(40)

            Divider()
              .color('#e5e5e5')
              .strokeWidth(1)
          }
          .margin({ left: 20, right: 20 })

          // 密码输入
          Column() {
            Row() {
              TextInput({ placeholder: $r('app.string.hint_pwd') })
                .type(this.showPassword ? InputType.Normal : InputType.Password)
                .maxLength(20)
                .fontSize(14)
                .fontColor('#333333')
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onChange((value: string) => {
                  this.password = value
                })

              Checkbox()
                .select(this.showPassword)
                .onChange((value: boolean) => {
                  this.showPassword = value
                })
                .width(30)
                .height(30)
            }
            .width('100%')
            .height(40)

            Divider()
              .color('#e5e5e5')
              .strokeWidth(1)
          }
          .margin({ left: 20, right: 20 })

          // 协议同意
          Row() {
            Checkbox()
              .select(this.agreePolicy)
              .onChange((value: boolean) => {
                this.agreePolicy = value
              })
              .width(18)
              .height(18)
              .margin({ right: 5 })

            Text($r('app.string.sign_in_agree'))
              .fontSize(14)

            Text($r('app.string.privacy_policy'))
              .fontSize(14)
              .fontColor('#999999')
              .onClick(() => {
                // 查看隐私政策
              })

            Text($r('app.string.user_agreement'))
              .fontSize(14)
              .fontColor('#999999')
              .margin({ left: 5 })
              .onClick(() => {
                // 查看用户协议
              })
          }
          .alignItems(VerticalAlign.Center)
          .margin({ left: 20, right: 20, top: 10 })

          // 登录按钮
          Button($r('app.string.login'))
            .width('100%')
            .height(48)
            .fontSize(16)
            .fontColor(Color.White)
            .backgroundColor('#007AFF')
            .borderRadius(24)
            .margin({ left: 30, right: 30, top: 50 })
            .onClick(() => {
              // 登录逻辑
            })

          // 注册和忘记密码
          Row() {
            Text($r('app.string.register'))
              .fontSize(13)
              .fontColor('#999999')
              .onClick(() => {
                // 跳转注册
              })

            Divider()
              .vertical(true)
              .height(15)
              .color('#e5e5e5')
              .strokeWidth(1)
              .margin({ left: 10, right: 10 })

            Text($r('app.string.forget_pwd'))
              .fontSize(13)
              .fontColor('#999999')
              .onClick(() => {
                // 忘记密码
              })
          }
          .justifyContent(FlexAlign.Center)
          .margin({ top: 15 })
        }

        Blank()

        // 底部设置区域
        Column() {
          Text($r('app.string.update_api'))
            .fontSize(14)
            .fontColor('#999999')
            .onClick(() => {
              // 更新API设置
            })

          Text($r('app.string.reset_base_url'))
            .fontSize(14)
            .fontColor('#007AFF')
            .margin({ top: 10 })
            .visibility(Visibility.None)
            .onClick(() => {
              // 重置基础URL
            })
        }
        .alignItems(HorizontalAlign.Center)
        .margin({ bottom: 50 })
        .visibility(Visibility.None)

        // 其他视图容器
        Stack()
          .width('100%')
          .height(50)
          .margin({ bottom: 30 })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f5f5f5')
  }
}