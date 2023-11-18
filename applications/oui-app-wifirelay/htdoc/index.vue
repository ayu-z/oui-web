<template>
  <n-card :title="$t('relay')">
    <n-tabs default-value="2.4" size="large" justify-content="space-evenly">
      <n-tab-pane name="2.4" :tab="$t('w2')">
        <br>
        <n-space justify="start" style="padding-left: 100px">
          <n-checkbox v-model:checked="formValue.keepEnable1">{{ $t('enable') }}</n-checkbox>
        </n-space>
        <br>
        <n-form size="large" ref="form" label-placement="left" label-width="100px" :model="formValue">
          <n-form-item :label="$t('ssid')" path="ssid">
            <n-input v-model:value="formValue.ssid" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('crypt')" path="crypt">
            <n-select v-model:value="formValue.crypt" :options="option1" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('passwd')" path="passwd">
            <n-input v-model:value="formValue.passwd" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('channel')" path="channel">
            <n-select v-model:value="formValue.channel" :options="option2" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('band')" path="band">
            <n-select v-model:value="formValue.band" :options="option3" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('power')" path="power">
            <n-select v-model:value="formValue.power" :options="option4" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('mode')">
            <n-input style="width: 200px"/>
          </n-form-item>
        </n-form>
      </n-tab-pane>

      <n-tab-pane name="5.8" :tab="$t('w5')">
        <br>
        <n-space justify="start" style="padding-left: 100px">
          <n-checkbox v-model:checked="formValue.keepEnable2">{{ $t('enable') }}</n-checkbox>
        </n-space>
        <br>
        <n-form size="large" ref="form1" label-placement="left" label-width="100px" :model="formValue1">
          <n-form-item :label="$t('ssid')" path="ssid">
            <n-input v-model:value="formValue1.ssid" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('crypt')" path="crypt">
            <n-select v-model:value="formValue1.crypt" :options="option1" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('passwd')" path="passwd">
            <n-input v-model:value="formValue1.passwd" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('channel')" path="channel">
            <n-select v-model:value="formValue1.channel" :options="option2" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('band')" path="band">
            <n-select v-model:value="formValue1.band" :options="option3" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('power')" path="power">
            <n-select v-model:value="formValue1.power" :options="option4" style="width: 200px"/>
          </n-form-item>
          <n-form-item :label="$t('mode')">
            <n-input style="width: 200px"/>
          </n-form-item>
        </n-form>
      </n-tab-pane>

    </n-tabs>
  </n-card>
</template>
<script>

export default {
  data() {
    return {

      formValue: {
        keepEnable1: false,
        ssid: 'WIFI-2.4G',
        crypt: '0',
        passwd: '654321',
        channel: '0',
        band: '0',
        power: '0'
      },
      formValue1: {
        keepEnable2: true,
        ssid: 'WIFI-5.8G',
        crypt: '1',
        passwd: '123456',
        channel: '1',
        band: '1',
        power: '1'
      },
      option1: [
        {label:'加密', value:'0'},
        {label:'不加密', value:'1'}
      ],
      option2: [
        {label:'auto', value:'0'},
        {label:'1', value:'1'},
        {label:'2', value:'2'},
        {label:'3', value:'3'}
      ],
      option3: [
        {label:'20MHz', value:'0'},
        {label:'40MHz', value:'1'},
        {label:'80MHz', value:'2'}
      ],
      option4: [
        {label:'高', value:'0'},
        {label:'中', value:'1'},
        {label:'低', value:'2'}
      ]
    }
  }
}
</script>
<i18n src="./locale.json"/>

