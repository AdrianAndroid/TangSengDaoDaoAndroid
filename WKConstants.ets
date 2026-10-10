import { preferences } from '@kit.ArkData'
import { deviceInfo } from '@kit.BasicServicesKit'
import { util } from '@kit.ArkTS'

export class WKConstants {
  static readonly refreshContacts: string = "refresh_contacts"
  static readonly newMsgChannelID: string = "wk_new_msg_notification"
  static readonly newRTCChannelID: string = "wk_new_rtc_notification"
  
  static imageDir: string = ""
  static videoDir: string = ""
  static voiceDir: string = ""
  static avatarCacheDir: string = ""
  static chatBgCacheDir: string = ""
  static messageBackupDir: string = ""
  static chatDownloadFileDir: string = ""
  
  private static keyboardHeight: number = 0

  // 软键盘高度
  static getKeyboardHeight(): number {
    if (this.keyboardHeight === 0) {
      this.keyboardHeight = WKSharedPreferencesUtil.getInstance().getInt("keyboardHeight")
    }
    return this.keyboardHeight
  }

  static setKeyboardHeight(height: number): void {
    if (height !== this.keyboardHeight) {
      this.keyboardHeight = height
      WKSharedPreferencesUtil.getInstance().putInt("keyboardHeight", height)
    }
  }

  static getDeviceUUID(): string {
    const uid = WKConfig.getInstance().getUid()
    let deviceUUID = WKSharedPreferencesUtil.getInstance().getSP(uid + "device_uuid")
    if (!deviceUUID) {
      deviceUUID = util.generateRandomUUID().replace(/-/g, "")
      WKSharedPreferencesUtil.getInstance().putSP(uid + "device_uuid", deviceUUID)
    }
    return deviceUUID
  }

  static getDeviceID(): string {
    let deviceID = deviceInfo.deviceId
    if (!deviceID) {
      deviceID = WKSharedPreferencesUtil.getInstance().getSP("device_id")
      if (!deviceID) {
        deviceID = util.generateRandomUUID().replace(/-/g, "")
        WKSharedPreferencesUtil.getInstance().putSP("device_id", deviceID)
      }
    }
    return deviceID
  }

  static isLogin(): boolean {
    return !!WKConfig.getInstance().getUid()
  }

  static getFontScale(): number {
    let fontScale = WKSharedPreferencesUtil.getInstance().getFloat("font_scale", 1)
    if (fontScale <= 0) {
      fontScale = 1
    }
    return fontScale
  }

  static setFontScale(fontSizeScale: number): void {
    WKSharedPreferencesUtil.getInstance().putFloat("font_scale", fontSizeScale)
  }
}

// 需要实现的工具类接口
interface WKConfig {
  getUid(): string
}

interface WKSharedPreferencesUtil {
  getInt(key: string): number
  putInt(key: string, value: number): void
  getSP(key: string): string
  putSP(key: string, value: string): void
  getFloat(key: string, defaultValue: number): number
  putFloat(key: string, value: number): void
}