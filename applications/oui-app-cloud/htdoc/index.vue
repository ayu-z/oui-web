<template>
  <div>
    <n-form size="large" ref="form" label-placement="left" label-width="auto" :model="formValue" :rules="rules">
      <n-form-item :label="$t('Enabled')" path="iotcloud">
        <n-select v-model="formValue.iotcloud" :options="transIotCloud" filterable />
      </n-form-item>
    </n-form>
    <n-space justify="end" style="padding-right: 100px">
      <n-button type="primary" :loading="loading" @click="handleSubmit">{{ $t('Save & Apply') }}</n-button>
    </n-space>
  </div>
</template>

<script>
export default {
  data() {
    return {
      formValue: {
        iotcloud: null
      },
      iotcloud: [
        'Disabled',
        'Default',
        'Custom'
      ]
    }
  },
  computed: {
    transIotCloud() {
      return this.iotcloud.map(option => ({
        value: option,
        label: this.$t(option)
      }))
    }
  }
}
</script>

<i18n src="./locale.json"/>