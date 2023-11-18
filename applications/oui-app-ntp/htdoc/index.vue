<template>
  <n-modal v-model:show="model" preset="dialog" :title="modify ? $t('Change') : $t('add')"
		:positive-text="$t('OK')"
		:negative-text="$t('Cancel')"
		@positive-click="addntp">
		<n-form ref="form" :model="formValue" :rules="rules" label-placement="left" label-width="auto">
			<n-form-item :label="$t('candidate')" path="candidate">
				<n-input v-model:value="formValue.candidate"/>
			</n-form-item>
		</n-form>
	</n-modal>

  <br>
    <n-space justify="start" style="padding-left: 150px">
      <n-checkbox v-model:checked="keepEnable1">{{ $t('client') }}</n-checkbox>
    </n-space>
  <br>
    <n-space justify="start" style="padding-left: 150px">
      <n-checkbox v-model:checked="keepEnable2">{{ $t('server') }}</n-checkbox>
    </n-space>
	<br>
  <n-data-table :row-key="r => r.id" :columns="columns" :data="users"/>
  <br>
	<n-space justify="end" style="padding-right: 100px">
		<n-button type="primary"  @click="showAdd">{{ $t('add') }}</n-button>
		<n-button type="primary"  :loading="loading" @click="saveconfig">{{ $t('save') }}</n-button>
	</n-space>
</template>

<script>
import { h, resolveComponent } from 'vue'

export default {
  data() {
    return {
      keepEnable1: false,
      keepEnable2: false,
      model: false,
      loading: false,
      modify: '',
      users: [],
      formValue: {
        candidate: ''
      },
      columns: [
        {
          title: () => this.$t('candidate'),
          key: 'candidate'
        },
        {
          key: 'actions',
          render: r => h(resolveComponent('n-space'), () => [
            //h(resolveComponent('n-button'), { type: 'primary', onClick: () => this.modifyntp(r) }, () => this.$t('Change')),
            h(resolveComponent('n-button'), { type: 'error', onClick: () => this.deletentp(r) }, () => this.$t('Delete'))
          ])
        }]
    }
  },

  methods: {
    showAdd() {
      this.modify = ''
      this.formValue.candidate = ''
      this.model = true
    },

    addntp() {
      return new Promise((resolve, reject) => {
        this.$refs.form.validate(errors => {
          if (errors) {
            reject()
            return
          }

          //修改一条规则
          if (this.modify) {
            this.getrules()
          } else {//添加一条规则
            this.$oui.call('ntp', 'addntp', {
              server: this.formValue.candidate
            }).then(() => {
              resolve()
              this.getNTPserver()
            })
          }
        })
      })
    },

    deletentp(user) {
      this.$dialog.create({
        content: this.$t('delete-user-confirm', { remark: user.candidate }),
        negativeText: this.$t('Cancel'),
        positiveText: this.$t('OK'),
        onPositiveClick: () => {
          this.$oui.call('ntp', 'deletentp', { server: user.candidate }).then(() => this.getNTPserver())
        }
      })
    },

    //修改规则
    modifyntp(r) {
      this.modify = r.id
      this.formValue.candidate = r.candidate
      this.model = true
    },

    saveconfig() {
      let enabled = Number(this.keepEnable1)
      let enable_server = Number(this.keepEnable2)
      this.loading = true
      this.$oui.call('uci', 'set', {
        config: 'system',
        section: 'ntp',
        values: { enabled, enable_server }
      })
      this.loading = false
      this.$message.success(this.$t('Configuration has been applied'))
    },
    getNTPserver() {
      this.$oui.call('ntp', 'getntp').then(({ users }) => {
        this.users = users
      })
    }
  },

  created() {
    this.getNTPserver()
    this.$oui.call('uci', 'get', {
      config: 'system',
      section: 'ntp',
      option: 'enabled'}).then(r => {
      if (r === '1') {
        this.keepEnable1 = true
      } else {
        this.keepEnable1 = false
      }
    })
    this.$oui.call('uci', 'get', {
      config: 'system',
      section: 'ntp',
      option: 'enable_server'}).then(r => {
      if (r === '1') {
        this.keepEnable2 = true
      } else {
        this.keepEnable2 = false
      }
    })
  }

}

</script>
<i18n src="./locale.json"/>
