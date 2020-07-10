require "spec_helper"

describe Glimmer do
  after do
    Glimmer::Config.import_swt_packages = true
    %w[
      SomeApp
      SomeWidget
      SomeShell
    ].each do |constant|
      Object.send(:remove_const, constant) if Object.const_defined?(constant)
    end    
    Glimmer::Config.send(:remove_class_variable, :@@import_swt_packages)
  end
  
  describe '::import_swt_packages' do
    it 'enables automatic include of SWT packages in Glimmer apps by default' do
      class SomeApp   
        include Glimmer
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq(Glimmer::Config::DEFAULT_IMPORT_SWT_PACKAGES)
      
      expect(SomeApp::Label).to eq(org.eclipse.swt.widgets.Label)
    end
  
    it 'explicitly enables automatic include of SWT packages in Glimmer apps' do
      Glimmer::Config.import_swt_packages = true
      
      class SomeApp
        include Glimmer
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq(Glimmer::Config::DEFAULT_IMPORT_SWT_PACKAGES)
      
      expect(SomeApp::Label).to eq(org.eclipse.swt.widgets.Label)    
    end
  
    it 'enables automatic include of SWT packages in Glimmer apps by specifying extra packages' do
      Glimmer::Config.import_swt_packages += [
        'org.eclipse.nebula.widgets.ganttchart'
      ]
      
      class SomeApp
        include Glimmer
      end
      
      expect(Glimmer::Config.import_swt_packages).to eq([
        'org.eclipse.swt',
        'org.eclipse.swt.widgets',
        'org.eclipse.swt.layout',
        'org.eclipse.swt.graphics',
        'org.eclipse.swt.browser',
        'org.eclipse.swt.custom',
        'org.eclipse.swt.dnd',
        'org.eclipse.nebula.widgets.ganttchart',
      ])
  
      expect(SomeApp::Label).to eq(org.eclipse.swt.widgets.Label)
    end
  
    it 'enables automatic include of SWT packages in Glimmer apps by specifying a limited set of packages' do
      Glimmer::Config.import_swt_packages = [
        'org.eclipse.swt',
        'org.eclipse.swt.widgets',
        'org.eclipse.swt.layout',
        'org.eclipse.swt.graphics',
        'org.eclipse.swt.browser',
      ]
      
      class SomeApp
        include Glimmer
      end
      
      expect(Glimmer::Config.import_swt_packages).to eq([
        'org.eclipse.swt',
        'org.eclipse.swt.widgets',
        'org.eclipse.swt.layout',
        'org.eclipse.swt.graphics',
        'org.eclipse.swt.browser',
      ])
  
      expect(SomeApp::Label).to eq(org.eclipse.swt.widgets.Label)
    end
  
    it 'disables automatic include of SWT packages in Glimmer apps' do
      Glimmer::Config.import_swt_packages = false    
      
      class SomeApp
        include Glimmer
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq(false)
      
      expect {SomeApp::Label}.to raise_error(NameError)
    end
  
    it 'disables automatic include of SWT packages in Glimmer apps via nil value' do
      Glimmer::Config.import_swt_packages = nil
      
      class SomeApp
        include Glimmer
      end
  
      expect(Glimmer::Config.import_swt_packages).to be_nil
      
      expect {SomeApp::Label}.to raise_error(NameError)
    end
  
    it 'disables automatic include of SWT packages in Glimmer apps via empty array value' do
      Glimmer::Config.import_swt_packages = []
      
      class SomeApp
        include Glimmer
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq([])
      
      expect {SomeApp::Label}.to raise_error(NameError)
    end
  
    it 'disables automatic include of SWT packages in Glimmer custom widgets' do
      Glimmer::Config.import_swt_packages = false
      
      class SomeWidget
        include Glimmer::UI::CustomWidget
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq(false)
      
      expect {SomeWidget::Label}.to raise_error(NameError)
    end
  
    it 'disables automatic include of SWT packages in Glimmer custom shells' do
      Glimmer::Config.import_swt_packages = false
      
      class SomeShell
        include Glimmer::UI::CustomShell
      end
  
      expect(Glimmer::Config.import_swt_packages).to eq(false)
      
      expect {SomeShell::Label}.to raise_error(NameError)
    end
  end

end
