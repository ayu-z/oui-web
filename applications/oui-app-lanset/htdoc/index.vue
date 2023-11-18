<template>
<n-card :title="$t('lan')">
  <br>
  <n-space style="padding-left: 100px">
          <n-button type="primary" @click="dialrun">{{ $t('save') }}</n-button>
  </n-space>
  <br>
  <n-form size="large" ref="form" label-placement="left" label-width="100px" :model="formValue">
		<n-form-item :label="$t('ip')" path="ip">
			<n-input v-model:value="formValue.ip" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('mask')" path="mask">
			<n-input v-model:value="formValue.mask" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('dns1')" path="dns1">
			<n-input v-model:value="formValue.dns1" style="width: 200px"/>
		</n-form-item>
    <n-form-item :label="$t('dns2')" path="dns2">
			<n-input v-model:value="formValue.dns2" style="width: 200px"/>
		</n-form-item>
  </n-form>
</n-card>
</template>
<script>
export default {
  data() {
    return {
      formValue: {
        ip: '',
        mask: '',
        dns1: '',
        dns2: ''
      }
    }
  }
}
</script>
<i18n src="./locale.json"/>
